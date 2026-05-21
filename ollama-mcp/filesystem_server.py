#!/usr/bin/env python3
"""MCP server — filesystem + shell tools.

Launched automatically as a subprocess by agent.py.
Not intended to be run directly.
"""

import subprocess
from pathlib import Path

from mcp.server.fastmcp import FastMCP

mcp = FastMCP("tools")


@mcp.tool()
def read_file(path: str) -> str:
    """Read the full contents of a file."""
    return Path(path).read_text(encoding="utf-8")


@mcp.tool()
def write_file(path: str, content: str) -> str:
    """Write (or overwrite) a file with the given content. Creates parent directories if needed."""
    p = Path(path)
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(content, encoding="utf-8")
    return f"Written: {path}"


@mcp.tool()
def list_directory(path: str = ".") -> str:
    """List files and subdirectories at the given path. Directories are shown first."""
    p = Path(path)
    # Sort key: dirs before files (is_file() → False < True), then alphabetically
    entries = sorted(p.iterdir(), key=lambda e: (e.is_file(), e.name))
    return "\n".join(
        f"{'[dir] ' if e.is_dir() else '[file]'} {e.name}" for e in entries
    ) or "(empty)"


@mcp.tool()
def run_shell(command: str, cwd: str = ".") -> str:
    """Run a shell command and return combined stdout + stderr.

    Caution: executes directly on the local machine.
    Hard-coded 30 s timeout prevents runaway commands from blocking the agent loop.
    """
    result = subprocess.run(
        command,
        shell=True,
        capture_output=True,
        text=True,
        cwd=cwd,
        timeout=30,
    )
    output = []
    if result.stdout:
        output.append(result.stdout)
    if result.stderr:
        output.append(f"[stderr]\n{result.stderr}")
    if result.returncode != 0:
        output.append(f"[exit code {result.returncode}]")
    return "\n".join(output) or "(no output)"


if __name__ == "__main__":
    mcp.run()
