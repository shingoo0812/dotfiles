#!/usr/bin/env python3
"""MCP server that exposes Ollama as tools.
Add this to Claude Desktop (or any MCP client) to call local models as a tool.

Claude Desktop config (~AppData/Roaming/Claude/claude_desktop_config.json):
{
  "mcpServers": {
    "ollama": {
      "command": "C:/Users/shingo/miniconda3/python.exe",
      "args": ["C:/Users/shingo/Documents/MCP/ollama-mcp/ollama_server.py"]
    }
  }
}
"""

import ollama
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("ollama")


@mcp.tool()
def ollama_chat(prompt: str, model: str = "llama3.2", system: str = "") -> str:
    """Send a prompt to a local Ollama model and return its response.

    Args:
        prompt: The user message.
        model: Ollama model name (default: llama3.2).
        system: Optional system prompt.
    """
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})
    response = ollama.chat(model=model, messages=messages)
    return response.message.content


@mcp.tool()
def ollama_list_models() -> str:
    """List all locally available Ollama models."""
    models = ollama.list()
    if not models.models:
        return "(no models installed — run: ollama pull llama3.2)"
    return "\n".join(m.model for m in models.models)


if __name__ == "__main__":
    mcp.run()
