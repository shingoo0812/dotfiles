import sys
import time
from pathlib import Path

from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from rich.console import Console
from rich.progress import (
    Progress, SpinnerColumn, BarColumn,
    MofNCompleteColumn, TimeElapsedColumn, TextColumn,
)

from indexer import Indexer
from config import WATCH_DIRS

console = Console(legacy_windows=False)


class DotfilesHandler(FileSystemEventHandler):
    def __init__(self, indexer: Indexer):
        self.indexer = indexer

    def on_created(self, event):
        if event.is_directory:
            return
        n = self.indexer.index_file(event.src_path)
        if n:
            console.print(f"[green]+[/green] {Path(event.src_path).name}  ({n} chunks)")

    def on_modified(self, event):
        if event.is_directory:
            return
        n = self.indexer.index_file(event.src_path)
        if n:
            console.print(f"[yellow]~[/yellow] {Path(event.src_path).name}  ({n} chunks)")

    def on_deleted(self, event):
        if event.is_directory:
            return
        self.indexer.remove_file(event.src_path)
        console.print(f"[red]-[/red] {Path(event.src_path).name}")

    def on_moved(self, event):
        if event.is_directory:
            return
        self.indexer.remove_file(event.src_path)
        n = self.indexer.index_file(event.dest_path)
        if n:
            console.print(
                f"[blue]->[/blue] {Path(event.src_path).name} -> {Path(event.dest_path).name}  ({n} chunks)"
            )


def main():
    indexer = Indexer()
    cached_count = len(indexer._mtime_cache)

    console.rule("[bold]Dotfiles RAG Watcher[/bold]")
    for d in WATCH_DIRS:
        console.print(f"Watching: [cyan]{d}[/cyan]")
    if cached_count:
        console.print(f"[dim]Cache: {cached_count:,} files already indexed - will be skipped.[/dim]")
    console.print()

    with console.status("[dim]Scanning for new/changed files...[/dim]"):
        pending, already_cached = indexer.collect_pending()

    console.print(
        f"[dim]Scan complete: {already_cached:,} unchanged, "
        f"[green]{len(pending):,}[/green] to index.[/dim]"
    )

    total_chunks = 0
    if pending:
        with Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            BarColumn(),
            MofNCompleteColumn(),
            TextColumn("•"),
            TextColumn("[green]{task.fields[chunks]}[/green] chunks"),
            TextColumn("•"),
            TimeElapsedColumn(),
            console=console,
        ) as progress:
            task = progress.add_task("Indexing...", total=len(pending), chunks=0)

            def on_file(path: str, n: int, total: int, skipped: int) -> None:
                nonlocal total_chunks
                total_chunks = total
                progress.advance(task)
                progress.update(task, description=f"[dim]{Path(path).name}[/dim]", chunks=total)

            total_chunks, _ = indexer.index_all(on_file=on_file)

    console.print(
        f"[green]Index ready:[/green] {total_chunks:,} new chunks  "
        f"[dim]({already_cached:,} files unchanged)[/dim]"
    )
    console.print("[dim]Watching for changes -- Ctrl+C to stop.[/dim]\n")

    handler = DotfilesHandler(indexer)
    observer = Observer()
    for d in WATCH_DIRS:
        observer.schedule(handler, d, recursive=True)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        pass
    finally:
        observer.stop()
        observer.join()
        console.print("\n[dim]Watcher stopped.[/dim]")


if __name__ == "__main__":
    main()
