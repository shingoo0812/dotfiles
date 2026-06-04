# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for a dual-environment setup: **Windows 11** (primary) and **Linux/WSL** (secondary). Configs are version-controlled here and deployed via symlinks.

## Symlink System (Linux)

`install/bootstrap.sh` is the Linux deployment script. It scans every `links.prop` file in the repo and creates symlinks:

```
$DOTFILES/source/path=~/.destination/path
```

To apply changes on Linux:
```bash
bash install/bootstrap.sh
```

`links.prop` files exist at multiple levels — each subdirectory can have its own. The root `linux/links.prop` maps `$DOTFILES/linux/` → `~/.config`.

## Symlink System (Windows)

`windows/install/bootstrap.ps1` is the Windows deployment script. It scans every `links.prop` file under `windows/` and creates symlinks.

```
$DOTFILES\source\file=$HOME\target\file
```

Supported variables in `links.prop`: `$DOTFILES`, `$HOME`, `$APPDATA`. Lines starting with `#` are comments.

To apply changes on Windows (run PowerShell as Administrator, or enable Developer Mode):
```powershell
powershell -ExecutionPolicy Bypass -File windows\install\bootstrap.ps1
# or to skip all prompts:
powershell -ExecutionPolicy Bypass -File windows\install\bootstrap.ps1 -Force
```

`links.prop` files live alongside the configs they describe:
- `windows/Claude/links.prop` — Claude.md, settings.json, claude_desktop_config.json
- `windows/wezterm/links.prop` — .wezterm.lua, keymap.lua
- `windows/PowerShell/links.prop` — profile files

## Package Management (Windows)

`windows/install/install-packages.ps1` reads three plain-text package lists and installs any missing packages (idempotent):

| File | Manager | Check installed |
|---|---|---|
| `windows/install/scoop.txt` | Scoop | `scoop list` |
| `windows/install/winget.txt` | WinGet (package IDs) | `winget list` |
| `windows/install/choco.txt` | Chocolatey | `choco list` |

One package/ID per line; lines starting with `#` are comments.

```powershell
powershell -ExecutionPolicy Bypass -File windows\install\install-packages.ps1
powershell -ExecutionPolicy Bypass -File windows\install\install-packages.ps1 -DryRun
```

## Package Management (Linux)

`linux/install/install-packages.sh` reads `apt.txt` and `brew.txt`:

```bash
bash linux/install/install-packages.sh
```

Homebrew packages are skipped if `brew` is not in PATH.

## Directory Map

| Directory | Purpose |
|---|---|
| `linux/` | Linux configs deployed via `links.prop` (zsh, tmux, bash, xfce4, lazygit, etc.) |
| `linux/install/` | Linux package lists (`apt.txt`, `brew.txt`), `install-packages.sh`, and `create_ssh.sh` |
| `windows/Claude/` | Claude Code settings, CLAUDE.md, and Claude Desktop config |
| `windows/PowerShell/` | PowerShell profile and aliases |
| `windows/wezterm/` | WezTerm terminal config (split into main + keymap) |
| `windows/install/` | Windows symlink bootstrap and package installer (`scoop.txt`, `winget.txt`, `choco.txt`) |
| `nvim/` | Neovim config (git submodule: shingoo0812/kickstart.nvim). Plugin list with descriptions: `nvim/plugins.md` |
| `ollama-mcp/` | Python MCP server exposing local Ollama models as tools |
| `rag/` | Personal RAG system: ChromaDB + Ollama embeddings + Claude API, served via MCP (`rag_query` tool) and CLI |
| `install/` | Linux symlink bootstrap (`bootstrap.sh`) — run `bash install/bootstrap.sh` to deploy symlinks |
| `Dockerfile/` | Docker compose configs (DokuWiki) |

## Submodules

```bash
git submodule update --init --recursive
```

- `nvim/` — fork of kickstart.nvim
- `linux/tmux/plugins/tpm` — Tmux Plugin Manager

## RAG

Personal search system combining ChromaDB (local vector DB) + Ollama embeddings + Claude API generation. See `rag/README.md` for full setup.

Quick reference:
- **Build/update index**: `python rag/watcher.py` (full scan + live watch)
- **Auto-start**: registered as Windows Task Scheduler job `DotfilesRAGWatcher` (triggers on logon); `LastTaskResult=267009` means it is still running (normal)
- **Interactive CLI**: `python rag/query_api.py` or `rag/query.bat`
- **MCP tools**: `rag_query(question)` and `rag_stats()` — already registered in `claude_desktop_config.json`

To rebuild from scratch: delete `rag/chroma_db/` and `rag/mtime_cache.json`, then re-run `watcher.py`.

## ollama-mcp

Local Python MCP server. Install dependencies once:
```bash
cd ollama-mcp
pip install -r requirements.txt   # requires: mcp>=1.9.0, ollama>=0.4.0
```

Run the standalone CLI agent (Ollama as LLM + filesystem tools):
```bash
python agent.py                    # default: llama3.2
python agent.py --model qwen2.5
```

`filesystem_server.py` is launched automatically as a subprocess by `agent.py` — do not run it directly. `ollama_server.py` is registered in Claude Desktop and Claude Code as an MCP server.

## Claude Code Configuration

`windows/Claude/settings.json` configures:
- **Hooks**:
  - Windows toast notifications via `BurntToast` on task completion and when awaiting input
  - Auto-deletes temp files after `Write` — matches paths under `$env:TEMP`/`$env:TMP`, `*.tmp`/`*.temp` extensions, and `tmp_*`/`temp_*` filenames (script: `~/.claude/hooks/cleanup-temp-files.ps1`)
  - Package list auto-update after `Bash`/`PowerShell` installs (script: `~/.claude/hooks/update-package-lists.ps1`)
- **Status line**: `npx -y ccstatusline@latest` refreshed every 10 seconds
- **MCP**: neovim server (requires nvim running with `--listen \\.\pipe\nvim`)

The global `CLAUDE.md` at `windows/Claude/Claude.md` contains system-wide rules (file operation priority, MCP timeout handling, Ollama tool usage policy). Edit it there — the symlink propagates automatically.

## WezTerm Config

Split into two files:
- `.wezterm.lua` — appearance, font, color scheme (Tokyo Night), tabs
- `keymap.lua` — all keybindings (imported as a Lua module)

## PowerShell Aliases

`windows/PowerShell/alias.ps1` is dot-sourced by the profile. Notable aliases:
- `v` — opens nvim with `--listen \\.\pipe\nvim` (for MCP)
- `f` — fzf file picker → opens in nvim
- `cdd` — jump to this dotfiles directory
- `cdv` — jump to nvim config
- `l` / `ll` — `dir -Force`
