#!/usr/bin/env python3
"""MCP server that exposes local Ollama models as tools for Claude Desktop.

Add to Claude Desktop config (%AppData%\Claude\claude_desktop_config.json):
{
  "mcpServers": {
    "ollama": {
      "command": "C:/Users/shingo/miniconda3/python.exe",
      "args": ["C:/Users/shingo/AppData/Local/dotfiles/ollama-mcp/ollama_server.py"]
    }
  }
}
"""

import ollama
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("ollama")

DEFAULT_MODEL = "llama3.2"


def _chat(prompt: str, model: str, system: str = "") -> str:
    """Send a prompt to Ollama. Returns [ERROR: ...] on failure so Claude can recover without user involvement."""
    try:
        messages = []
        if system:
            messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": prompt})
        return ollama.chat(model=model, messages=messages).message.content
    except ollama.ResponseError as e:
        return f"[ERROR: model_error: {e}]"
    except Exception as e:
        # Catches connection refused (Ollama not running), timeout, etc.
        return f"[ERROR: {type(e).__name__}: {e}]"


# ---------------------------------------------------------------------------
# General
# ---------------------------------------------------------------------------

@mcp.tool()
def ollama_chat(prompt: str, model: str = DEFAULT_MODEL, system: str = "") -> str:
    """Send a prompt to a local Ollama model and return its response.

    Args:
        prompt: The user message.
        model: Ollama model name (default: llama3.2).
        system: Optional system prompt.
    """
    return _chat(prompt, model, system)


@mcp.tool()
def ollama_list_models() -> str:
    """List all locally available Ollama models."""
    try:
        models = ollama.list()
        if not models.models:
            return "(no models installed — run: ollama pull llama3.2)"
        return "\n".join(m.model for m in models.models)
    except Exception as e:
        return f"[ERROR: {type(e).__name__}: {e}]"


# ---------------------------------------------------------------------------
# Efficiency tools — offload mechanical tasks from Claude to a local model
# ---------------------------------------------------------------------------

@mcp.tool()
def ollama_summarize(text: str, max_words: int = 200, model: str = DEFAULT_MODEL) -> str:
    """Summarize text locally. Use for text longer than 500 words to reduce tokens sent to Claude.

    Args:
        text: The text to summarize.
        max_words: Target word count for the summary (default: 200).
        model: Ollama model name.
    """
    prompt = (
        f"Summarize the following text in {max_words} words or fewer. "
        "Be concise and capture all key points:\n\n"
        f"{text}"
    )
    return _chat(prompt, model)


@mcp.tool()
def ollama_extract_json(text: str, schema_hint: str, model: str = DEFAULT_MODEL) -> str:
    """Extract structured data from text and return it as JSON.

    Use when you need to parse unstructured text into a known shape without
    spending Claude tokens on a mechanical extraction task.

    Args:
        text: Source text to extract from.
        schema_hint: Description of the expected JSON fields (e.g. "name, date, amount").
        model: Ollama model name.
    """
    prompt = (
        "Extract the following information from the text and return it as valid JSON only "
        "(no explanation, no markdown fences).\n\n"
        f"Expected fields: {schema_hint}\n\n"
        f"Text:\n{text}"
    )
    return _chat(prompt, model)


@mcp.tool()
def ollama_draft_commit(diff: str, model: str = DEFAULT_MODEL) -> str:
    """Draft a git commit message from a diff output.

    Args:
        diff: Output of `git diff` or `git diff --cached`.
        model: Ollama model name.
    """
    prompt = (
        "Write a git commit message for the following diff.\n"
        "Format: one short subject line (50 chars max), blank line, then optional bullet-point body.\n"
        "Focus on WHY the change was made, not a literal description of what changed.\n\n"
        f"{diff}"
    )
    return _chat(prompt, model)


@mcp.tool()
def ollama_triage_log(log_text: str, model: str = DEFAULT_MODEL) -> str:
    """Extract errors, warnings, and anomalies from log output.

    Use to filter large logs before passing the result to Claude for diagnosis.

    Args:
        log_text: Raw log content.
        model: Ollama model name.
    """
    prompt = (
        "Analyze the following log output. Extract and list:\n"
        "1. Errors (include surrounding context lines)\n"
        "2. Warnings\n"
        "3. Anomalies or suspicious patterns\n"
        "Be concise. Write 'none' for any category with no findings.\n\n"
        f"{log_text}"
    )
    return _chat(prompt, model)


@mcp.tool()
def ollama_batch(prompts: list[str], model: str = DEFAULT_MODEL) -> str:
    """Run multiple prompts through Ollama in sequence and return all results.

    Claude (supervisor) uses this to assign a list of mechanical subtasks to
    Ollama (executor) in one call, then reviews the combined output.

    Each result is prefixed with its index. Errors are marked [ERROR: ...] so
    Claude can identify which items failed and retry or handle them directly.

    Args:
        prompts: List of prompts to run.
        model: Ollama model name applied to all prompts.
    """
    results = []
    for i, prompt in enumerate(prompts, 1):
        result = _chat(prompt, model)
        results.append(f"[{i}] {result}")
    return "\n\n".join(results)


if __name__ == "__main__":
    mcp.run()
