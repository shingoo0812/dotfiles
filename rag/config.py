from pathlib import Path

# --- Watch directories (whitelist) ---
# Add directories here to include them in the index.
DOTFILES_DIR = r"C:\Users\shingo\AppData\Local\dotfiles"
HOUDINI_DIR  = r"C:\Users\shingo\Documents\houdini21.0"
# OBSIDIAN_DIR = r"F:\Documents\ObsidianVault"
# WORK_DIR     = r"F:\Work"

WATCH_DIRS = [
    DOTFILES_DIR,
    HOUDINI_DIR,
]

RAG_DIR          = str(Path(__file__).parent)
CHROMA_DIR       = str(Path(__file__).parent / "chroma_db")
MTIME_CACHE_PATH = Path(__file__).parent / "mtime_cache.json"

EMBED_MODEL    = "nomic-embed-text"
GENERATE_MODEL = "claude-sonnet-4-6"

# --- Documentation-only file types ---
SUPPORTED_EXTENSIONS = {
    ".md",    # Markdown — READMEs, notes, CLAUDE.md, wiki pages
    ".txt",   # Plain text
    ".rst",   # reStructuredText
    ".wiki",  # VimWiki markup
    ".ipynb", # Jupyter notebooks (used as study/learning notes)
}

# --- Directory names to skip (applied across all watch dirs) ---
EXCLUDE_DIRS = {
    ".git",
    "__pycache__", ".venv", "venv", "node_modules",
    "chroma_db",
    ".claude",
    "vimwiki_html",
    # Houdini — bundled Python libs and simulation/cache output
    "python3.7libs", "python3.9libs", "python3.10libs", "python3.11libs",
    "otls", "sim", "cache", "backup",
}

# --- Specific filenames to skip ---
EXCLUDE_FILES = {
    "nvim-pack-lock.json",
}

CHUNK_SIZE    = 800   # characters per chunk
CHUNK_OVERLAP = 100   # characters of overlap between chunks
TOP_K         = 5     # chunks returned per query
