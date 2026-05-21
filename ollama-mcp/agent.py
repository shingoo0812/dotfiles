#!/usr/bin/env python3
"""CLI agent: Ollama LLM + MCP filesystem tools.

Usage:
    python agent.py                    # uses llama3.2
    python agent.py --model mistral
"""

import argparse
import asyncio
import json
import sys
from contextlib import AsyncExitStack

import ollama
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client


def _mcp_tool_to_ollama(tool) -> dict:
    """Convert an MCP tool descriptor to the format Ollama's chat API expects."""
    return {
        "type": "function",
        "function": {
            "name": tool.name,
            "description": tool.description or "",
            "parameters": tool.inputSchema,
        },
    }


def _build_assistant_message(msg) -> dict:
    """Build an assistant history entry from an Ollama response message."""
    entry: dict = {"role": "assistant", "content": msg.content or ""}
    if msg.tool_calls:
        entry["tool_calls"] = [
            {"function": {"name": tc.function.name, "arguments": tc.function.arguments}}
            for tc in msg.tool_calls
        ]
    return entry


async def _execute_tool_calls(tool_calls, tool_to_session: dict) -> list[dict]:
    """Execute each tool call via MCP and return tool-result messages."""
    results = []
    for tc in tool_calls:
        name = tc.function.name
        args = tc.function.arguments or {}
        print(f"  [tool] {name}({json.dumps(args, ensure_ascii=False)})")

        session = tool_to_session.get(name)
        if session:
            result = await session.call_tool(name, args)
            content = "\n".join(c.text for c in result.content if hasattr(c, "text"))
        else:
            content = f"Error: unknown tool '{name}'"

        results.append({"role": "tool", "content": content})
    return results


async def _agentic_turn(
    model: str,
    messages: list[dict],
    ollama_tools: list[dict],
    tool_to_session: dict,
) -> None:
    """Run one user turn, looping until the model stops requesting tool calls."""
    while True:
        response = await asyncio.to_thread(
            ollama.chat,
            model=model,
            messages=messages,
            tools=ollama_tools,
        )
        msg = response.message
        messages.append(_build_assistant_message(msg))

        if not msg.tool_calls:
            print(f"\nAssistant: {msg.content}\n")
            break

        # Feed tool results back so the model can continue reasoning
        tool_results = await _execute_tool_calls(msg.tool_calls, tool_to_session)
        messages.extend(tool_results)


async def run(model: str) -> None:
    # Launch filesystem_server.py as a child process; communicate via MCP over stdio
    server_params = StdioServerParameters(
        command=sys.executable,
        args=["filesystem_server.py"],
    )

    async with AsyncExitStack() as stack:
        read, write = await stack.enter_async_context(stdio_client(server_params))
        session = await stack.enter_async_context(ClientSession(read, write))
        await session.initialize()

        tools_result = await session.list_tools()
        tool_to_session = {t.name: session for t in tools_result.tools}
        ollama_tools = [_mcp_tool_to_ollama(t) for t in tools_result.tools]

        print(f"Ollama MCP Agent  (model: {model})")
        print(f"Tools: {[t['function']['name'] for t in ollama_tools]}")
        print("Type 'quit' to exit.\n")

        messages: list[dict] = []

        while True:
            try:
                user_input = input("You: ").strip()
            except (EOFError, KeyboardInterrupt):
                print()
                break
            if not user_input:
                continue
            if user_input.lower() in ("quit", "exit", "q"):
                break

            messages.append({"role": "user", "content": user_input})
            await _agentic_turn(model, messages, ollama_tools, tool_to_session)


def main() -> None:
    parser = argparse.ArgumentParser(description="Ollama + MCP CLI agent")
    parser.add_argument("--model", default="llama3.2", help="Ollama model name")
    args = parser.parse_args()
    asyncio.run(run(args.model))


if __name__ == "__main__":
    main()
