# Personal RAG System

A local RAG (Retrieval-Augmented Generation) system that indexes your personal files into a vector database and lets you query them with Claude.

Indexed sources:
- `C:\Users\shingo\AppData\Local\dotfiles` — dotfiles and configs
- `F:\Documents\ObsidianVault` — Obsidian notes
- `C:\Users\shingo\Documents\houdini21.0` — Houdini scripts and configs
- `F:\Work` — work projects

---

## Prerequisites

| Requirement | Notes |
|---|---|
| Python | Miniconda at `C:\Users\shingo\miniconda3\python.exe` |
| Ollama | Must be running locally (`ollama serve`) |
| nomic-embed-text | `ollama pull nomic-embed-text` |
| Anthropic API key | Required for `query_api.py` (not for indexing) |

---

## Setup

```powershell
cd rag
pip install -r requirements.txt
```

Create `.env` with your API key:
```
ANTHROPIC_API_KEY=sk-ant-...
```

---

## Usage

### Three entry points

| Script | Purpose | How to run |
|---|---|---|
| `watcher.py` | Build/update the index + watch for changes | `python watcher.py` |
| `query_api.py` | Interactive CLI — asks Claude using retrieved context | `python query_api.py` or `query.bat` |
| `rag_server.py` | MCP server for Claude Desktop / Claude Code | launched automatically |

### First run

Build the index (scans all watch directories):

```powershell
python watcher.py
```

This does a full scan on first run, then switches to live file watching (Ctrl+C to stop). Re-run any time to pick up changes, or keep it running in the background.

### Interactive CLI

```powershell
python query_api.py
# or
query.bat
```

Type a question at the `>` prompt. The system retrieves the top 5 relevant chunks from the index and sends them to Claude as context. Type `quit` to exit.

### MCP tools (Claude Desktop / Claude Code)

The RAG server is already registered in `claude_desktop_config.json` as `"rag"` and exposes two tools:

| Tool | Description |
|---|---|
| `rag_query(question, top_k=5)` | Search the index and return relevant chunks |
| `rag_stats()` | Return total chunks and files indexed |

Claude can call these tools automatically when you ask about your files, notes, or configs.

---

## Configuration

All settings live in `config.py`:

| Setting | Default | Description |
|---|---|---|
| `WATCH_DIRS` | 4 paths | Directories to index |
| `EMBED_MODEL` | `nomic-embed-text` | Ollama model for embeddings |
| `GENERATE_MODEL` | `claude-sonnet-4-6` | Claude model for answers (CLI only) |
| `CHUNK_SIZE` | `800` | Characters per chunk |
| `CHUNK_OVERLAP` | `100` | Overlap between chunks |
| `TOP_K` | `5` | Chunks returned per query |
| `SUPPORTED_EXTENSIONS` | 40+ types | File types to index |
| `EXCLUDE_DIRS` | 50+ names | Directory names to skip |

To add a watch directory, append to `WATCH_DIRS` and re-run `watcher.py`.

---

## Architecture

```
Watch directories
       │
       ▼
  watcher.py ──── scans & monitors files
       │
       ▼
  indexer.py ──── chunks text (800 chars, 100 overlap)
       │            embeds via Ollama (nomic-embed-text)
       │            stores in ChromaDB (chroma_db/)
       │            tracks mtimes (mtime_cache.json)
       ▼
  chroma_db/ ◄─── rag_server.py  (MCP: rag_query tool)
                   query_api.py  (CLI: Claude answers)
```

Incremental indexing: files are only re-embedded when their modification time changes. A full re-index from scratch: delete `chroma_db/` and `mtime_cache.json`, then run `watcher.py`.
