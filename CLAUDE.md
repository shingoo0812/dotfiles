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

No automated script — Windows symlinks are created manually with PowerShell:
```powershell
New-Item -ItemType SymbolicLink -Path "<target>" -Target "<source in dotfiles>"
```

Key Windows symlinks already in place:
- `windows/Claude/Claude.md` → `~/.claude/CLAUDE.md`
- `windows/Claude/settings.json` → `~/.claude/settings.json`
- `windows/Claude/claude_desktop_config.json` → `%AppData%/Claude/claude_desktop_config.json`
- `windows/wezterm/.wezterm.lua` + `keymap.lua` → `~/.wezterm.lua` etc.

## Directory Map

| Directory | Purpose |
|---|---|
| `linux/` | Linux configs deployed via `links.prop` (zsh, tmux, bash, xfce4, lazygit, etc.) |
| `windows/Claude/` | Claude Code settings, CLAUDE.md, and Claude Desktop config |
| `windows/PowerShell/` | PowerShell profile and aliases |
| `windows/wezterm/` | WezTerm terminal config (split into main + keymap) |
| `nvim/` | Neovim config (git submodule: shingoo0812/kickstart.nvim) |
| `ollama-mcp/` | Python MCP server exposing local Ollama models as tools |
| `install/` | Linux bootstrap and install scripts |
| `Dockerfile/` | Docker compose configs (DokuWiki) |

## Submodules

```bash
git submodule update --init --recursive
```

- `nvim/` — fork of kickstart.nvim
- `linux/tmux/plugins/tpm` — Tmux Plugin Manager

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
- **Hooks**: Windows toast notifications via `BurntToast` on task completion and when awaiting input
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
