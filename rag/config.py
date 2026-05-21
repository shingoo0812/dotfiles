from pathlib import Path

DOTFILES_DIR  = r"C:\Users\shingo\AppData\Local\dotfiles"
OBSIDIAN_DIR  = r"F:\Documents\ObsidianVault"
HOUDINI_DIR   = r"C:\Users\shingo\Documents\houdini21.0"
WORK_DIR      = r"F:\Work"
WATCH_DIRS    = [DOTFILES_DIR, OBSIDIAN_DIR, HOUDINI_DIR, WORK_DIR]

RAG_DIR         = str(Path(__file__).parent)
CHROMA_DIR      = str(Path(__file__).parent / "chroma_db")
MTIME_CACHE_PATH = Path(__file__).parent / "mtime_cache.json"

EMBED_MODEL    = "nomic-embed-text"
GENERATE_MODEL = "claude-sonnet-4-6"

SUPPORTED_EXTENSIONS = {
    # documents & notes
    ".md", ".wiki", ".txt", ".rst", ".csv",
    # shell & scripting
    ".py", ".sh", ".ps1", ".zsh", ".bat", ".cmd", ".bashrc", ".zshrc", ".zsh_aliases",
    # web / TS
    ".ts", ".js", ".html", ".css",
    # systems / graphics code
    ".cpp", ".c", ".h", ".hpp", ".cs", ".lua",
    # shaders (Houdini VEX + GLSL)
    ".vex", ".vfl", ".frag", ".vert", ".glsl",
    # Maya / Houdini scripts
    ".mel", ".hscript",
    # Houdini text configs
    ".shelf", ".pref", ".prefs", ".desk", ".def", ".pypanel", ".radialmenu",
    # structured data / config
    ".json", ".xml", ".yml", ".yaml", ".toml", ".cfg", ".ini", ".conf",
    ".prop", ".env", ".envrc", ".editorconfig", ".clang-format",
    # dotfile extensions (no dot in suffix)
    ".gitconfig", ".gitignore", ".gitattributes", ".gitmodules",
    ".dockerignore", ".scm", ".rc",
    # notebooks & templates
    ".ipynb", ".j2", ".template",
    # misc text
    ".ocio", ".code-workspace",
}

# directory names to skip entirely (applied across all watch dirs)
EXCLUDE_DIRS = {
    # RAG internals
    "rag", "chroma_db",
    # version control
    ".git",
    # Python environments & caches
    ".venv", "venv", "__pycache__", "node_modules",
    "site-packages",        # catches any Python venv (nerfstudio_env, etc.)
    "pip_prebundle",        # pre-bundled pip packages (Omniverse SDK)
    # Obsidian internals
    ".obsidian", "images",
    # Houdini bundled Python libs (thousands of stdlib files, not your code)
    "python3.7libs", "python3.9libs", "python3.10libs", "python3.11libs",
    # Houdini binary asset dirs
    "otls", "backup", "asset_store",
    # build / dist artifacts
    "build", "dist", "target", "bin", "obj",
    # simulation / cache data
    "sim", "cache",
    # Unity engine-generated cache (not user content)
    "Library", "PackageCache", "Packages",
    "Localization",
    # old vimwiki HTML export
    "vimwiki_html",
    # backup folders in Work
    "presets_BK",
    # Python venv directories with non-standard names
    "nerfstudio_env",
    # F:\Work — tool software asset dirs (binary/non-searchable)
    "Blender", "Cubase", "Gaea", "Mari", "Materialize_1.78",
    "QuixelMixer", "WorldMachine", "Zbrush", "MAYA", "Maya_Projects",
    "UE", "CAD", "Electronic", "Substance",
    # F:\Work — dependency/external code dirs inside projects
    "deps", "extlibs", "vendor", "third_party", "thirdparty", "_repo",
    # F:\Work — template/asset dirs
    "templates", "Adobe",
}

# specific filenames to skip
EXCLUDE_FILES = {
    "cookie", "nvim-pack-lock.json", ".netcoredbg_hist", ".lastpippull",
}

CHUNK_SIZE    = 800   # characters per chunk
CHUNK_OVERLAP = 100   # characters of overlap between chunks
TOP_K         = 5     # chunks returned per query
