# Claude.md — System Configuration and Rules

## 1. Meta Rules

### Documentation Language

**`CLAUDE.md` must always be written in English.**
- CLAUDE.md is for Claude to read and follow — English ensures token efficiency and clarity
- When creating or updating CLAUDE.md, always use English

**`.claude/overview.md` and `.claude/notes.md` may be written in Japanese.**
- These are human-readable documents; use whatever language is most natural for the user

---

## 2. File & Tool Operations

### Tool Priority Order
- **Windows paths**: Attempt operations via PowerShell MCP first
- **Linux paths** (`/home/...`): Provide bash or Python commands for user to run in terminal
- **WSL files from Windows tools**: Use `wslpath -w` to convert the path first

### Size Check Before Reading
**Always check size before reading files or log output:**
- Files: `Get-Item <path> | Select-Object Length` — if large (>200 lines or >50KB), use `ollama_summarize`
- Command output: estimate line count first — if >~100 lines, pipe through `ollama_triage_log`
- Git logs: check `git log --oneline | Measure-Object -Line` first if history may be long

### Target-Based Write Tool Selection

**Windows filesystem (`C:\Users\...`):**
- ALWAYS use PowerShell `Set-Content -Encoding UTF8` or `Out-File -Encoding UTF8`
- For content with complex quotes, write a Python script file first then execute

**Linux filesystem (`/home/...`):**
- Provide short bash commands for user to run in terminal
- For large files (>500 lines), prioritize `filesystem:edit_file` (diff-style) to prevent timeout
- For complex content with quotes, use Python heredoc:

```bash
python3 << 'EOF'
open("/path/to/file", "w").write("content")
EOF
```

### On Failure
- Stop immediately and report the error
- Do NOT automatically try alternative tools
- Let user decide next step

---

## 3. MCP & PowerShell Rules

### Timeout Prevention (60-second limit)
All MCP server operations (PowerShell, Neovim, filesystem) have a 60-second timeout.

**If using Neovim MCP, request permission first — the user may already be using it.**

**Strategies:**
- Break work into small steps; avoid long-running commands
- Limit file reads: use `-TotalCount`, `-Tail`, or `head`/`tail`
- Process data in chunks

**Tool selection:**
- Short commands: `powershell:execute-powershell`
- Complex operations: `create-powershell-script` -> `execute-powershell-script`
- File edits: `filesystem:edit_file` for simple replacements, scripts for complex changes

**When timeout occurs:**
- Create a script file, then execute (avoids inline timeout)
- Redirect output to temp file: `command > temp.txt 2>&1; Get-Content temp.txt`
- Switch to bash tool if PowerShell times out repeatedly

```powershell
# Bad: may timeout on large directory
Get-ChildItem -Recurse

# Good: limited scope
Get-ChildItem -Recurse -Depth 2 | Select-Object -First 100
```

### Command Size & Atomicity
- **No inline bloat**: Single-line commands must not exceed 1000 characters. For large payloads, use `create-powershell-script` to write a `.ps1` file first.
- **Atomic steps**: Separate write and verify into distinct tool calls.
- **No multi-level escaping**: Don't wrap Python inside PowerShell strings. Use `Set-Content` with `@' ... '@` here-strings.
- **Fail fast**: If a command may exceed 45 seconds, split it or use background execution.

### Python Execution

**Always use full Python path** (`python` command not available in MCP):
- Python 3.12: `C:\Users\shing\AppData\Local\Programs\Python\Python312\python.exe`
- Python 3.10: `C:\Users\shing\AppData\Local\Programs\Python\Python310\python.exe`
- Scoop: `C:\Users\shing\scoop\apps\python\current\python.exe`
- Priority: `.venv` (if exists) -> Global 3.12 -> Scoop

**Mandatory flags:**
- Always include `-u` (unbuffered output — required for MCP)
- Default to Python 3.12 unless specified

**Every new script must start with:**
```python
import sys
sys.stdout.reconfigure(line_buffering=True)
sys.stderr.reconfigure(line_buffering=True)
```

**Prohibited:**
- Never use `python` directly
- Never omit `-u`
- Never partial-rewrite a file (causes timeout) — rewrite fully with `Set-Content` or use `create-powershell-script`
- Never omit `-Encoding UTF8` for PowerShell file writes

**If no output appears:**
1. Redirect to file: `python.exe -u script.py > output.txt 2>&1; Get-Content output.txt`
2. Switch to bash tool if PowerShell MCP fails repeatedly

---

## 4. Package List Maintenance

A PostToolUse hook auto-updates list files when packages are installed, but always verify it ran for non-standard invocations.

### Dotfiles lists (always update — files always exist)

| Manager | List file |
|---|---|
| `scoop install` | `dotfiles/windows/install/scoop.txt` |
| `winget install` | `dotfiles/windows/install/winget.txt` |
| `choco install` | `dotfiles/windows/install/choco.txt` |
| `apt install` | `dotfiles/linux/install/apt.txt` |
| `brew install` | `dotfiles/linux/install/brew.txt` |

### Project-local lists (create if missing, then update)

| Manager | List file |
|---|---|
| `pip install` | `requirements.txt` |
| `conda install` | `conda-packages.txt` |
| `scoop install` | `scoop.txt` |

One package per line. No version pins unless a specific version is required.

---

## 5. New Project Setup

A `SessionStart` hook checks the working directory at the start of every session.
If it reports missing setup, **ask the user before doing anything else**:

| Hook message | Ask the user |
|---|---|
| `.git not found` | 「このフォルダはgit管理されていません。git initしますか？」 |
| `Not in RAG WATCH_DIRS` | 「このフォルダはRAGの対象外です。rag/config.pyのWATCH_DIRSに追加しますか？」 |
| `No CLAUDE.md found` | 「このプロジェクトにCLAUDE.mdがありません。テンプレートから作成しますか？」 |

If multiple issues exist, ask all in one message. Wait for the user's answer before proceeding with their original request.

A `Stop` hook auto-commits changed repos and reminds about CLAUDE.md updates when hooks/settings changed.

### Project File Templates

Templates are stored at `~/.claude/templates/` (managed in dotfiles under `windows/Claude/templates/`).

| Template | Deploy to | Purpose |
|---|---|---|
| `CLAUDE.md.tmpl` | `<project>/CLAUDE.md` | Claude rules for this project |
| `overview.md.tmpl` | `<project>/.claude/overview.md` | Project context for Claude and user |
| `notes.md.tmpl` | `<project>/.claude/notes.md` | Accumulated knowledge from sessions |

### Document Rules

| File | Language | Claude reads automatically? | Purpose |
|---|---|---|---|
| `CLAUDE.md` | English only | Yes — every session | Claude behavior rules for this project |
| `.claude/overview.md` | Japanese OK | Only when user asks | Human-readable project context |
| `.claude/notes.md` | Japanese OK | Only when user asks | Human-readable work log |

**notes.md** is a work log for the user, not a Claude behavior file:
- Write investigation logs, build recipes, bug fix histories, configuration decisions
- Do NOT write Claude behavior rules here — those go in `CLAUDE.md` or memory
- Do NOT read or reference `notes.md` unless the user explicitly asks ("notes.mdを見て" etc.)
- When memory entries are completed/resolved, migrate their detail to `notes.md` then delete from memory
- Create only when the user explicitly requests it

**When creating project files from templates:**
1. Copy template to destination, replacing `[Project Name]` with the actual name
2. Remove sections marked `<!-- Remove this section if ... -->` that don't apply
3. Fill in placeholders with project-specific information
4. `CLAUDE.md` contains **Claude rules only** — constraints, Python paths, git structure, gotchas
5. User-facing information (commands, directory map, key files) goes in `.claude/overview.md`

---

## 6. RAG Usage

A RAG MCP server (`mcp__rag__rag_query`) indexes documentation and Python source code across watch directories.

### What RAG covers
- **Documentation**: `.md`, `.txt`, `.rst`, `.wiki`, `.ipynb`
- **Source code**: `.py` files (chunked by function/class via AST)

### What RAG does NOT cover
- Config values in `.json`, `.toml`, `.cfg`, `.yaml` — read the file directly
- File paths and directory structure — use `Glob` or direct filesystem search
- Binary files, models, compiled output

### When to Query RAG
- "How does function/class X work?" → query RAG, then read the file to confirm
- Before editing Python code: query RAG for related functions/classes that might be affected, then **read those files directly** before making changes
- "What does project X do?" → query RAG for an overview

### Rules
- If RAG returns no relevant results, fall back to `Glob`/`Read` — do not treat absence of RAG results as absence of information
- RAG results are a starting point; always verify with direct file reads before making code changes
- Do not query RAG for file paths or config values — use dedicated tools instead

---

## 6. Ollama Integration

Claude is the **supervisor**; Ollama is the **executor**.
Claude plans, judges, and synthesizes. Ollama handles mechanical, high-volume, or privacy-sensitive subtasks.

### Pre-Read Size Check (Required)
Before reading any file or log output, check its size:

| Content | Check | Threshold | Action |
|---|---|---|---|
| File | `Get-Item <path> \| Select-Object Length` | >50KB or >200 lines | Use `ollama_summarize` |
| Command/log output | Count lines | >~100 lines | Use `ollama_triage_log` first |
| User-supplied text | Estimate word count | >~500 words | Use `ollama_summarize` first |

### When to Use Each Tool

| Task | Tool |
|---|---|
| Reading large files or user-supplied text (>~500 words) | `ollama_summarize` |
| Parsing unstructured text into structured fields | `ollama_extract_json` |
| Writing a git commit message | `ollama_draft_commit` (pass `git diff --cached`) |
| Filtering a large log file (>~100 lines) | `ollama_triage_log` |
| Multiple independent mechanical subtasks | `ollama_batch` |
| One-off local model query | `ollama_chat` |

### Rules
- **Always** use `ollama_summarize` before reading user-supplied text >~500 words
- **Always** use `ollama_triage_log` before analyzing raw log output >~100 lines
- **Always check size first** before using `Read` or analyzing command output
- Prefer `ollama_draft_commit` for commit messages unless the diff is architecturally complex
- Do **not** use Ollama for reasoning, code architecture, or security decisions — handle those directly
- **Always review** Ollama's output before using it — treat it as a draft, not a final answer

### Autonomous Error Resolution
All Ollama tools return `[ERROR: ...]` strings on failure. Resolve silently:

| Error pattern | Resolution |
|---|---|
| `model_error: model ... not found` | Call `ollama_list_models`, pick available model, retry |
| `[ERROR]` in one `ollama_batch` item | Retry individually; if fails again, handle directly |
| `ConnectError` / `connection refused` | Ollama is not running — inform the user |
| Malformed JSON from `ollama_extract_json` | Retry once with stricter prompt; parse manually if retry fails |
| Any other `[ERROR]` | Retry once; escalate to user only if retry fails |
