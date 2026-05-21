import os
import sys
from pathlib import Path
from dotenv import load_dotenv
import anthropic

load_dotenv(Path(__file__).parent / ".env")
from rich.console import Console
from rich.markdown import Markdown
from rich.panel import Panel

from indexer import Indexer
from config import GENERATE_MODEL, TOP_K

console = Console(legacy_windows=False)

SYSTEM_PROMPT = (
    "You are a personal assistant with full access to the user's dotfiles, "
    "configuration files, shell scripts, Neovim setup, and personal wiki notes.\n"
    "Answer questions based strictly on the retrieved context provided. "
    "Reference specific file names and content when relevant. "
    "If the answer is not present in the context, say so clearly rather than guessing."
)


def build_context(results: dict) -> str:
    parts = []
    for doc, meta in zip(results["documents"][0], results["metadatas"][0]):
        parts.append(f"[{meta['rel_path']}]\n{doc}")
    return "\n\n---\n\n".join(parts)


def ask(question: str, indexer: Indexer, client: anthropic.Anthropic) -> str:
    results = indexer.query(question, top_k=TOP_K)

    if not results["documents"][0]:
        return "No relevant content found in your dotfiles."

    context = build_context(results)
    user_content = f"Context from dotfiles:\n\n{context}\n\nQuestion: {question}"

    response = client.messages.create(
        model=GENERATE_MODEL,
        max_tokens=1024,
        system=[
            {
                "type": "text",
                "text": SYSTEM_PROMPT,
                "cache_control": {"type": "ephemeral"},  # cache the system prompt
            }
        ],
        messages=[{"role": "user", "content": user_content}],
    )

    return response.content[0].text


def main():
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        console.print("[red]ANTHROPIC_API_KEY is not set.[/red]")
        sys.exit(1)

    client = anthropic.Anthropic(api_key=api_key)
    indexer = Indexer()

    count = indexer.stats()
    if count == 0:
        console.print("[yellow]Index is empty. Run watcher.py first to build the index.[/yellow]")

    console.rule("[bold]Dotfiles RAG[/bold]")
    console.print(f"{count} chunks indexed. Type [bold]quit[/bold] to exit.\n")

    while True:
        try:
            question = console.input("[bold cyan]> [/bold cyan]").strip()
        except (KeyboardInterrupt, EOFError):
            break

        if question.lower() in ("quit", "exit", "q"):
            break
        if not question:
            continue

        with console.status("Searching and generating..."):
            answer = ask(question, indexer, client)

        console.print(Panel(Markdown(answer), border_style="dim"))
        console.print()


if __name__ == "__main__":
    main()
