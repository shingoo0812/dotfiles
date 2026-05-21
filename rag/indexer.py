import os
import json
import time
import hashlib
from pathlib import Path

import chromadb
import ollama

from config import (
    WATCH_DIRS, CHROMA_DIR, EMBED_MODEL,
    SUPPORTED_EXTENSIONS, EXCLUDE_DIRS, EXCLUDE_FILES,
    CHUNK_SIZE, CHUNK_OVERLAP, TOP_K, MTIME_CACHE_PATH,
)

FLUSH_INTERVAL = 500   # persist mtime cache to disk every N indexed files
FLUSH_SECONDS  = 30    # also flush if this many seconds have passed

_FILE_ATTRIBUTE_REPARSE_POINT = 0x400


def _is_reparse_point(entry: os.DirEntry) -> bool:
    """Return True if entry is a Windows junction point or symlink (reparse point)."""
    try:
        attrs = entry.stat(follow_symlinks=False).st_file_attributes
        return bool(attrs & _FILE_ATTRIBUTE_REPARSE_POINT)
    except (AttributeError, OSError):
        return False


class Indexer:
    def __init__(self):
        self.client = chromadb.PersistentClient(path=CHROMA_DIR)
        self.collection = self.client.get_or_create_collection(
            name="dotfiles",
            metadata={"hnsw:space": "cosine"},
        )
        self._mtime_cache: dict[str, float] = self._load_mtime_cache()
        self._dirty = 0
        self._last_flush = time.monotonic()

    # ------------------------------------------------------------------ #
    # Mtime cache                                                          #
    # ------------------------------------------------------------------ #

    def _load_mtime_cache(self) -> dict[str, float]:
        try:
            return json.loads(MTIME_CACHE_PATH.read_text(encoding="utf-8"))
        except Exception:
            return {}

    def flush_mtime_cache(self) -> None:
        try:
            MTIME_CACHE_PATH.write_text(
                json.dumps(self._mtime_cache), encoding="utf-8"
            )
            self._dirty = 0
            self._last_flush = time.monotonic()
        except Exception:
            pass

    def _mark_indexed(self, abs_path: str, mtime: float) -> None:
        self._mtime_cache[abs_path] = mtime
        self._dirty += 1
        elapsed = time.monotonic() - self._last_flush
        if self._dirty >= FLUSH_INTERVAL or elapsed >= FLUSH_SECONDS:
            self.flush_mtime_cache()

    # ------------------------------------------------------------------ #
    # Chunking                                                             #
    # ------------------------------------------------------------------ #

    def _chunk(self, text: str) -> list[str]:
        lines = text.splitlines()
        chunks, current, current_len = [], [], 0

        for line in lines:
            line_len = len(line) + 1
            if current_len + line_len > CHUNK_SIZE and current:
                chunks.append("\n".join(current))
                tail, tail_len = [], 0
                for l in reversed(current):
                    if tail_len + len(l) + 1 <= CHUNK_OVERLAP:
                        tail.insert(0, l)
                        tail_len += len(l) + 1
                    else:
                        break
                current, current_len = tail, tail_len
            current.append(line)
            current_len += line_len

        if current:
            chunks.append("\n".join(current))

        return [c for c in chunks if c.strip()]

    # ------------------------------------------------------------------ #
    # Embedding                                                            #
    # ------------------------------------------------------------------ #

    def _embed(self, text: str) -> list[float]:
        response = ollama.embed(model=EMBED_MODEL, input=text, keep_alive="10m")
        return response.embeddings[0]

    # ------------------------------------------------------------------ #
    # Path helpers                                                         #
    # ------------------------------------------------------------------ #

    def _rel_path(self, abs_path: str) -> str:
        p = Path(abs_path)
        for base in WATCH_DIRS:
            try:
                return str(p.relative_to(base))
            except ValueError:
                continue
        return abs_path

    # ------------------------------------------------------------------ #
    # File filtering                                                       #
    # ------------------------------------------------------------------ #

    def _should_index(self, path: str) -> bool:
        p = Path(path)

        for part in p.parts:
            if part in EXCLUDE_DIRS:
                return False

        if p.name in EXCLUDE_FILES:
            return False

        ext = p.suffix.lower()
        if ext in SUPPORTED_EXTENSIONS:
            return True

        if ext == "" and not p.name.startswith("."):
            return False
        if p.name.startswith(".") and ext == "":
            return True

        return False

    # ------------------------------------------------------------------ #
    # Public API                                                           #
    # ------------------------------------------------------------------ #

    def index_file(self, path: str, mtime: float | None = None) -> int:
        """Embed and store a single file.

        Pass mtime from a prior scandir call to skip a redundant stat().

        Returns:
            n > 0  — indexed, n chunks added
            0      — ineligible / empty / error
            -1     — skipped (already up to date)
        """
        abs_path = str(Path(path).resolve())

        if not self._should_index(abs_path):
            return 0

        if mtime is None:
            try:
                st = Path(abs_path).stat()
                if st.st_size > 1_000_000:
                    return 0
                mtime = st.st_mtime
            except Exception:
                return 0

        if self._mtime_cache.get(abs_path) == mtime:
            return -1  # already indexed with same mtime

        try:
            text = Path(abs_path).read_text(encoding="utf-8", errors="ignore")
        except Exception:
            return 0

        if not text.strip():
            return 0

        self.remove_file(abs_path)

        chunks = self._chunk(text)
        rel_path = self._rel_path(abs_path)

        ids, embeddings, documents, metadatas = [], [], [], []
        for i, chunk in enumerate(chunks):
            try:
                emb = self._embed(chunk)
            except Exception:
                continue
            chunk_id = f"{hashlib.md5(abs_path.encode()).hexdigest()}::{i}"
            ids.append(chunk_id)
            embeddings.append(emb)
            documents.append(chunk)
            metadatas.append({
                "source":   abs_path,
                "rel_path": rel_path,
                "chunk":    i,
                "ext":      Path(abs_path).suffix,
                "mtime":    mtime,
            })

        if not ids:
            return 0

        for i in range(0, len(ids), 5000):
            self.collection.add(
                ids=ids[i:i+5000],
                embeddings=embeddings[i:i+5000],
                documents=documents[i:i+5000],
                metadatas=metadatas[i:i+5000],
            )

        self._mark_indexed(abs_path, mtime)
        return len(ids)

    def remove_file(self, path: str) -> None:
        abs_path = str(Path(path).resolve())
        try:
            self.collection.delete(where={"source": abs_path})
        except Exception:
            pass
        self._mtime_cache.pop(abs_path, None)

    def collect_pending(self) -> tuple[list[tuple[str, float]], int]:
        """Walk all WATCH_DIRS with scandir, capturing mtime from the dir entry.

        Returns (pending, skipped_count) where pending is a list of
        (abs_path, mtime) for files that are new or changed since last index.
        Already-cached unchanged files are filtered out here so the progress
        bar only counts work that actually needs doing.
        """
        pending: list[tuple[str, float]] = []
        skipped = 0
        stack = list(WATCH_DIRS)
        while stack:
            current = stack.pop()
            try:
                with os.scandir(current) as it:
                    for entry in it:
                        if entry.is_dir(follow_symlinks=False):
                            if entry.name in EXCLUDE_DIRS:
                                pass
                            elif _is_reparse_point(entry):
                                pass  # skip junction points / symlinks to outside dirs
                            else:
                                stack.append(entry.path)
                        elif entry.is_file(follow_symlinks=False):
                            if not self._should_index(entry.path):
                                continue
                            try:
                                st = entry.stat()
                                if st.st_size > 1_000_000:
                                    continue
                                mtime = st.st_mtime
                            except Exception:
                                continue
                            abs_path = str(Path(entry.path).resolve())
                            if self._mtime_cache.get(abs_path) == mtime:
                                skipped += 1
                            else:
                                pending.append((abs_path, mtime))
            except (PermissionError, FileNotFoundError, OSError):
                pass
        return pending, skipped

    def index_all(self, on_file=None) -> tuple[int, int]:
        """Scan all WATCH_DIRS and index new/changed files.

        Returns (total_new_chunks, skipped_file_count).
        on_file(path, n, total_new_chunks, skipped) called after each pending file.
        """
        pending, skipped = self.collect_pending()
        total = 0
        try:
            for abs_path, mtime in pending:
                n = self.index_file(abs_path, mtime=mtime)
                if n > 0:
                    total += n
                if on_file:
                    on_file(abs_path, n, total, skipped)
        finally:
            self.flush_mtime_cache()
        return total, skipped

    def query(self, text: str, top_k: int = TOP_K) -> dict:
        emb = self._embed(text)
        return self.collection.query(
            query_embeddings=[emb],
            n_results=top_k,
            include=["documents", "metadatas", "distances"],
        )

    def stats(self) -> int:
        return self.collection.count()
