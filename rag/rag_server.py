#!/usr/bin/env python3
"""MCP server exposing the personal RAG index as tools for Claude."""

import sys
from pathlib import Path

from mcp.server.fastmcp import FastMCP

mcp = FastMCP("rag")

sys.path.insert(0, str(Path(__file__).parent))

_indexer = None


def _get_indexer(reset: bool = False):
    global _indexer
    if _indexer is None or reset:
        from indexer import Indexer
        _indexer = Indexer()
    return _indexer


def _warmup():
    """Load ChromaDB index and Ollama model into memory at startup."""
    import ollama
    from config import EMBED_MODEL
    _get_indexer()
    ollama.embed(model=EMBED_MODEL, input="warmup")


_warmup()


@mcp.tool()
def rag_query(question: str, top_k: int = 5) -> str:
    """Search the personal RAG index for content relevant to a question.

    The index contains dotfiles, Obsidian notes, Houdini configs, shell scripts,
    and work files. Use this whenever the user asks about their personal
    environment, configurations, notes, or local files.

    Args:
        question: Natural language question or search query.
        top_k: Number of chunks to return (default: 5).
    """
    for attempt in range(2):
        try:
            indexer = _get_indexer(reset=(attempt > 0))
            results = indexer.query(question, top_k=top_k)
            docs = results["documents"][0]
            metas = results["metadatas"][0]
            distances = results["distances"][0]

            if not docs:
                return "No relevant content found in the index."

            parts = []
            for doc, meta, dist in zip(docs, metas, distances):
                relevance = round((1 - dist) * 100, 1)
                parts.append(f"[{meta['rel_path']}] (relevance: {relevance}%)\n{doc}")

            return "\n\n---\n\n".join(parts)
        except Exception as e:
            if attempt == 0:
                _indexer = None  # force reconnect on retry
                continue
            return f"[ERROR: {type(e).__name__}: {e}]"


@mcp.tool()
def rag_stats() -> str:
    """Return RAG index statistics: total chunks indexed and number of cached files."""
    try:
        indexer = _get_indexer()
        chunks = indexer.stats()
        files = len(indexer._mtime_cache)
        return f"{chunks:,} chunks indexed across {files:,} files"
    except Exception as e:
        return f"[ERROR: {type(e).__name__}: {e}]"


if __name__ == "__main__":
    mcp.run()
