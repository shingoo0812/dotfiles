# Personal RAG System

A local RAG (Retrieval-Augmented Generation) system that indexes personal documentation into a vector database and answers questions via Claude.

---

## Design

**Documentation only.** Only human-written documentation is indexed — no source code, no config files, no generated output. This keeps the index small, relevant, and fast.

**Whitelist directories.** Instead of watching broad roots and excluding noise, only explicitly listed directories are indexed. Add a directory to `WATCH_DIRS` in `config.py` to include it.

**Current watch list:**

| Directory | Contents |
|---|---|
| `C:\Users\shingo\AppData\Local\dotfiles` | READMEs, CLAUDE.md, plugin list, install docs |
| `C:\Users\shingo\Documents\houdini21.0` | Houdini documentation and notes |

**Indexed file types:** `.md` `.txt` `.rst` `.wiki` `.ipynb`

---

## Prerequisites

| Requirement | Notes |
|---|---|
| Python | Miniconda at `C:\Users\shingo\miniconda3\python.exe` |
| Ollama | Must be running locally — `ollama serve` |
| nomic-embed-text | `ollama pull nomic-embed-text` |
| Anthropic API key | Required for `query_api.py` only (not for indexing) |

---

## Setup

```powershell
cd rag
pip install -r requirements.txt
```

Create `.env` with your API key (used by `query_api.py`):
```
ANTHROPIC_API_KEY=sk-ant-...
```

---

## Usage

### Entry points

| Script | Purpose | Command |
|---|---|---|
| `watcher.py` | Build/update the index + watch for changes | `python watcher.py` |
| `query_api.py` | Interactive CLI — retrieves context and asks Claude | `python query_api.py` or `query.bat` |
| `rag_server.py` | MCP server for Claude Desktop / Claude Code | launched by Claude automatically |

### First run — build the index

```powershell
python watcher.py
```

Scans all `WATCH_DIRS`, embeds new/changed files, then enters live watch mode (Ctrl+C to stop). Re-run any time to catch changes, or keep running in the background for continuous updates.

### Interactive CLI

```powershell
python query_api.py
```

Type a question at the `>` prompt. The system retrieves the top 5 relevant chunks and sends them to Claude as context. Type `quit` to exit.

### MCP tools (Claude Desktop / Claude Code)

Registered as `"rag"` in `claude_desktop_config.json`. Exposes two tools:

| Tool | Description |
|---|---|
| `rag_query(question, top_k=5)` | Search the index and return relevant chunks with relevance scores |
| `rag_stats()` | Return total chunks and files currently indexed |

---

## Auto-start (Windows Task Scheduler)

`watcher.py` is registered as a Task Scheduler job named **`DotfilesRAGWatcher`** that launches automatically on user logon.

| Field | Value |
|---|---|
| Task name | `DotfilesRAGWatcher` |
| Trigger | On logon (`shingo`) |
| Executable | `C:\Users\shingo\miniconda3\python.exe` |
| Arguments | `C:\Users\shingo\AppData\Local\dotfiles\rag\watcher.py` |
| Working dir | `C:\Users\shingo\AppData\Local\dotfiles\rag` |

**Check status:**
```powershell
Get-ScheduledTask -TaskName DotfilesRAGWatcher | Get-ScheduledTaskInfo
```

A `LastTaskResult` of `267009` (0x41301) means the task is **currently running** — this is normal.

**Re-register if lost** (run PowerShell as Administrator):
```powershell
$action = New-ScheduledTaskAction `
    -Execute 'C:\Users\shingo\miniconda3\python.exe' `
    -Argument 'C:\Users\shingo\AppData\Local\dotfiles\rag\watcher.py' `
    -WorkingDirectory 'C:\Users\shingo\AppData\Local\dotfiles\rag'
$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
Register-ScheduledTask -TaskName 'DotfilesRAGWatcher' -Action $action -Trigger $trigger -RunLevel Highest -Force
```

---

## Configuration (`config.py`)

### Adding a watch directory

Append to `WATCH_DIRS`:

```python
WATCH_DIRS = [
    DOTFILES_DIR,
    HOUDINI_DIR,
    r"F:\Documents\ObsidianVault",  # example
]
```

Then rebuild the index (see below).

### Adding a file type

Append to `SUPPORTED_EXTENSIONS`:

```python
SUPPORTED_EXTENSIONS = {
    ".md", ".txt", ".rst", ".wiki", ".ipynb",
    ".org",  # example
}
```

### Settings reference

| Setting | Value | Description |
|---|---|---|
| `WATCH_DIRS` | 2 paths | Directories to index (whitelist) |
| `EMBED_MODEL` | `nomic-embed-text` | Ollama model used for embeddings |
| `GENERATE_MODEL` | `claude-sonnet-4-6` | Claude model used for answers (CLI only) |
| `CHUNK_SIZE` | `800` | Characters per chunk |
| `CHUNK_OVERLAP` | `100` | Overlap between adjacent chunks |
| `TOP_K` | `5` | Chunks returned per query |
| `SUPPORTED_EXTENSIONS` | 5 types | Documentation file types to index |
| `EXCLUDE_DIRS` | 8 names | Directory names to skip within watch dirs |

---

## Rebuilding the index

Required after changing `WATCH_DIRS`, `SUPPORTED_EXTENSIONS`, or `EXCLUDE_DIRS`:

```powershell
cd rag
Remove-Item -Recurse -Force chroma_db, mtime_cache.json
python watcher.py
```

---

## Architecture

```
WATCH_DIRS (whitelist)
       │
       ▼
  watcher.py ── scans for new/changed docs, watches for live changes
       │
       ▼
  indexer.py ── splits into chunks (800 chars, 100 overlap)
       │          embeds via Ollama (nomic-embed-text)
       │          stores in ChromaDB (chroma_db/)
       │          caches file mtimes (mtime_cache.json)
       ▼
  chroma_db/
       ▲
       ├── rag_server.py  →  MCP tools: rag_query, rag_stats
       └── query_api.py   →  interactive CLI (Claude API)
```

Incremental indexing: files are skipped if their modification time is unchanged since the last run. Only new or modified files are re-embedded.
