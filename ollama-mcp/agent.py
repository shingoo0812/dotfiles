#!/usr/bin/env python3
"""CLI agent: Ollama LLM + MCP tools (filesystem + shell).

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


def to_ollama_tool(tool) -> dict:
    return {
        "type": "function",
        "function": {
            "name": tool.name,
            "description": tool.description or "",
            "parameters": tool.inputSchema,
        },
    }


async def run(model: str) -> None:
    # sys.executable picks the correct Python automatically (Windows or WSL)
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
        ollama_tools = [to_ollama_tool(t) for t in tools_result.tools]

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

            # Agentic loop — repeat until the model stops calling tools
            while True:
                response = await asyncio.to_thread(
                    ollama.chat,
                    model=model,
                    messages=messages,
                    tools=ollama_tools,
                )
                msg = response.message

                # Record assistant turn
                assistant_msg: dict = {"role": "assistant", "content": msg.content or ""}
                if msg.tool_calls:
                    assistant_msg["tool_calls"] = [
                        {"function": {"name": tc.function.name, "arguments": tc.function.arguments}}
                        for tc in msg.tool_calls
                    ]
                messages.append(assistant_msg)

                if not msg.tool_calls:
                    print(f"\nAssistant: {msg.content}\n")
                    break

                # Execute each tool call via MCP
                for tc in msg.tool_calls:
                    name = tc.function.name
                    args = tc.function.arguments or {}
                    print(f"  [tool] {name}({json.dumps(args, ensure_ascii=False)})")

                    mcp_session = tool_to_session.get(name)
                    if mcp_session:
                        result = await mcp_session.call_tool(name, args)
                        content = "\n".join(
                            c.text for c in result.content if hasattr(c, "text")
                        )
                    else:
                        content = f"Error: unknown tool '{name}'"

                    messages.append({"role": "tool", "content": content})


def main() -> None:
    parser = argparse.ArgumentParser(description="Ollama + MCP CLI agent")
    parser.add_argument("--model", default="llama3.2", help="Ollama model name")
    args = parser.parse_args()
    asyncio.run(run(args.model))


if __name__ == "__main__":
    main()
