# Neovim Plugins

Managed by Neovim 0.12 built-in pack system (`vim.pack.add`).
Plugin configs live in `lua/plugins/`. Update this file with Claude when adding or removing plugins.

---

## Core Dependencies

- **nvim-lua/plenary.nvim** — Lua utility library required by many plugins; provides async, file I/O, testing, and path utilities
- **nvim-tree/nvim-web-devicons** — File type icons using Nerd Fonts; used by file explorers, statuslines, and tab bars
- **MunifTanjim/nui.nvim** — UI component library for building popup menus, input prompts, and floating layouts
- **folke/snacks.nvim** — Collection of small quality-of-life utilities: dashboard, image preview, notifier, picker, and more
- **nvim-lualine/lualine.nvim** — Fast and configurable statusline with theme support
- **ibhagwan/fzf-lua** — Fuzzy finder UI using fzf; replaces Telescope for file picking, live grep, buffer switching, LSP actions
- **lukas-reineke/indent-blankline.nvim** — Renders indent guide lines in code buffers
- **nvim-tree/nvim-tree.lua** — File explorer tree sidebar

---

## Treesitter

- **nvim-treesitter/nvim-treesitter** — Syntax-aware parsing engine for highlighting, folding, indentation, and text objects
- **nvim-treesitter/nvim-treesitter-context** — Sticky header showing the current function/class scope while scrolling

---

## Theme

- **neanias/everforest-nvim** — Everforest color scheme; warm, soft green-based palette designed for long coding sessions
- **sainnhe/gruvbox-material** — Gruvbox Material color scheme; retro warm earth tones, softer than the original gruvbox

---

## UI

- **folke/which-key.nvim** — Popup keybinding hints when pressing leader or modifier keys; self-documenting keymap explorer
- **nvim-neo-tree/neo-tree.nvim** — Full-featured file system, buffer, and git status explorer sidebar
- **s1n7ax/nvim-window-picker** — Interactive labeled window picker for focusing or splitting windows
- **romgrk/barbar.nvim** — Tabline / buffer bar with draggable tabs, file icons, and pin support
- **lewis6991/gitsigns.nvim** — Git diff signs in the gutter, inline blame, hunk staging and navigation
- **folke/trouble.nvim** — Diagnostics, LSP references, TODOs, and quickfix list in a collapsible sidebar
- **Bekaboo/dropbar.nvim** — IDE-like breadcrumb bar in the winbar showing current symbol and scope path
- **nvim-telescope/telescope-fzf-native.nvim** — Native fzf C extension for Telescope; improves sorting performance
- **shellRaining/hlchunk.nvim** — Highlights the current code block/chunk with a vertical colored line
- **rcarriga/nvim-notify** — Animated floating notification system replacing the default `vim.notify`
- **stevearc/oil.nvim** — File manager that opens the directory as an editable buffer; rename, delete, move by editing text
- **HiPhish/rainbow-delimiters.nvim** — Rainbow-colored matching brackets, parentheses, and braces
- **bassamsdata/namu.nvim** — LSP document symbol picker and navigator with fuzzy search
- **eero-lehtinen/oklch-color-picker.nvim** — In-editor OKLCH color picker for CSS and design work
- **nosduco/remote-sshfs.nvim** — Mount and browse remote filesystems over SSHFS directly in Neovim
- **folke/zen-mode.nvim** — Distraction-free writing mode; centers the buffer and hides all UI chrome

---

## Completion

- **hrsh7th/nvim-cmp** — Extensible completion engine; aggregates sources (LSP, snippets, paths, etc.)
- **L3MON4D3/LuaSnip** — Snippet engine with support for VS Code snippets and complex custom snippets
- **rafamadriz/friendly-snippets** — Community snippet collection for many languages in VS Code format
- **saadparwaiz1/cmp_luasnip** — LuaSnip adapter source for nvim-cmp
- **hrsh7th/cmp-nvim-lsp** — LSP source for nvim-cmp; provides symbol completions from language servers
- **hrsh7th/cmp-path** — Filesystem path completion source for nvim-cmp

---

## Editing

- **kevinhwang91/nvim-ufo** — Modern fold provider using LSP/treesitter with fold preview on hover
- **kevinhwang91/promise-async** — Async promise/coroutine library; dependency for nvim-ufo
- **echasnovski/mini.nvim** — Suite of small focused modules: surround, text objects, align, statusline, pairs, and more
- **folke/flash.nvim** — Fast cursor jumping with labeled targets across the visible buffer (like hop/easymotion)
- **numToStr/Comment.nvim** — Smart line and block commenting with `gcc` / `gbc` and visual mode support
- **windwp/nvim-autopairs** — Automatic bracket and quote pairing with treesitter and completion awareness
- **rmagatti/auto-session** — Session manager that auto-saves on exit and restores sessions per working directory
- **chentoast/marks.nvim** — Enhanced mark display with gutter signs and improved navigation commands
- **rainbowhxch/accelerated-jk.nvim** — Gradually accelerates `j`/`k` cursor speed when held down
- **sphamba/smear-cursor.nvim** — Animated smear effect on the cursor for visual movement tracking
- **mg979/vim-visual-multi** — Multiple cursors support similar to VS Code multi-cursor editing
- **junegunn/vim-easy-align** — Interactive text alignment by delimiter using the `ga` motion
- **benlubas/molten-nvim** — Run Jupyter notebook cells inline inside Neovim with output rendered in the buffer
- **jmbuhr/otter.nvim** — Enables LSP features for code blocks embedded inside Markdown/Quarto documents
- **willothy/wezterm.nvim** — WezTerm terminal integration; split panes and navigate from Neovim
- **3rd/image.nvim** — Renders images inline in Neovim buffers (requires Kitty/WezTerm terminal support)
- **jbyuki/venn.nvim** — Draw ASCII/Unicode diagrams, arrows, and boxes in normal mode
- **GCBallesteros/jupytext.nvim** — Transparently edit `.ipynb` Jupyter notebooks as Python or Markdown via jupytext
- **folke/noice.nvim** — Modern UI replacement for the cmdline, messages, and pop-up menu using floating windows

---

## LSP & Formatting

- **neovim/nvim-lspconfig** — Official configurations for 100+ language servers (LSP client setup)
- **williamboman/mason.nvim** — LSP server, DAP adapter, linter, and formatter installer and manager
- **williamboman/mason-lspconfig.nvim** — Bridge between mason.nvim and nvim-lspconfig for automatic server setup
- **WhoIsSethDaniel/mason-tool-installer.nvim** — Automatically installs a declared list of mason tools on startup
- **rhysd/vim-clang-format** — Clang-format integration for formatting C/C++/Objective-C code
- **Decodetalkers/csharpls-extended-lsp.nvim** — Extended C# language server support including decompilation and go-to-definition in libraries
- **j-hui/fidget.nvim** — LSP progress spinner and status messages shown in the statusline corner
- **stevearc/conform.nvim** — Formatter plugin with multi-formatter support and format-on-save
- **dnlhc/glance.nvim** — Peek at LSP definitions, references, and implementations in an inline floating window
- **danymat/neogen** — Auto-generates docstring and annotation templates for functions and classes
- **nvimtools/none-ls.nvim** — Integrates non-LSP tools (linters, formatters, diagnostics) as virtual LSP sources
- **antosha417/nvim-lsp-file-operations** — Notifies the LSP server when files are renamed or moved (for workspace refactoring)
- **rachartier/tiny-inline-diagnostic.nvim** — Shows LSP diagnostics inline at the end of the affected line

---

## Git

- **kdheepak/lazygit.nvim** — Opens lazygit in a floating terminal inside Neovim; full git TUI integration

---

## Search & Replace

- **nvim-telescope/telescope.nvim** — Extensible fuzzy finder for files, grep, LSP symbols, git, and custom pickers
- **nvim-telescope/telescope-ui-select.nvim** — Routes `vim.ui.select()` calls through Telescope for a consistent picker UI
- **MagicDuck/grug-far.nvim** — Interactive find-and-replace using ripgrep; results shown and edited in a buffer

---

## Debugging & Testing

- **mfussenegger/nvim-dap** — Debug Adapter Protocol (DAP) client; breakpoints, step through, inspect variables
- **rcarriga/nvim-dap-ui** — UI panels for nvim-dap: variables, call stack, breakpoints, and console
- **nvim-neotest/nvim-nio** — Async I/O library; dependency for neotest and nvim-dap-ui
- **jay-babu/mason-nvim-dap.nvim** — Auto-installs DAP adapters via mason
- **leoluz/nvim-dap-go** — Go debug adapter configuration for nvim-dap
- **mfussenegger/nvim-dap-python** — Python debug adapter (debugpy) configuration for nvim-dap
- **nvim-neotest/neotest** — Test runner framework with a unified interface for multiple test adapters
- **antoinemadec/FixCursorHold.nvim** — Fixes `CursorHold` event performance issues; dependency for neotest
- **nvim-neotest/neotest-python** — Python test adapter for neotest (supports pytest and unittest)
- **haydenmeade/neotest-jest** — Jest test adapter for neotest
- **timtro/glslView-nvim** — Live GLSL shader preview using glslViewer; hot-reload shaders while editing

---

## AI

- **coder/claudecode.nvim** — Claude Code CLI integration; connects Neovim to Claude Code via MCP for AI-assisted editing
- **olimorris/codecompanion.nvim** — AI coding assistant supporting Claude, OpenAI, Ollama, and other LLM providers inline
- **David-Kunz/gen.nvim** — Run Ollama models directly in Neovim with custom prompts and inline output
- **ravitemer/mcphub.nvim** — MCP (Model Context Protocol) server hub manager for AI tool integrations

---

## Markdown & Wiki

- **OXY2DEV/markview.nvim** — Renders Markdown inline in the buffer: headings, tables, code blocks, math (no external preview)
- **epwalsh/obsidian.nvim** — Obsidian vault integration: note linking, backlinks, template insertion, daily notes, search
- **vimwiki/vimwiki** — Personal wiki and note-taking system with its own wiki markup and link syntax

---

## Database

- **tpope/vim-dadbod** — Database client for Neovim; execute SQL queries against multiple DB types
- **kristijanhusak/vim-dadbod-ui** — UI frontend for vim-dadbod with a connection sidebar and query history
- **kristijanhusak/vim-dadbod-completion** — SQL keyword and schema completion via nvim-cmp using vim-dadbod

---

## Miscellaneous

- **kalvinpearce/ShaderHighlight** — GLSL and HLSL shader syntax highlighting
- **lambdalisue/vim-suda** — Read and write files requiring sudo privileges from within Neovim
- **tpope/vim-unimpaired** — Pairs of complementary `[` / `]` bracket mappings for navigating lists and toggles
- **folke/persistence.nvim** — Directory-aware session save and restore
- **mistweaverco/kulala.nvim** — HTTP client for REST API testing; send requests from `.http` files inside Neovim
- **potamides/pantran.nvim** — Translation plugin supporting multiple translation engines (DeepL, Google, etc.)
- **folke/todo-comments.nvim** — Highlights TODO/FIXME/NOTE/HACK comments and makes them searchable via Telescope
- **EvWilson/spelunk.nvim** — Named bookmark manager with a floating UI and navigation between saved positions
- **akinsho/toggleterm.nvim** — Persistent terminal windows that can be toggled open/close per terminal instance
- **uga-rosa/translate.nvim** — Translation plugin supporting DeepL, Google Translate, and other services
- **ThePrimeagen/harpoon** — Fast file bookmarking; mark up to 4 files and switch between them instantly
- **gruvw/strudel.nvim** — Live coding integration with Strudel (JavaScript pattern sequencer for algorithmic music)
- **andweeb/presence.nvim** — Discord rich presence integration showing the current file and project in Discord
- **ray-x/lsp_signature.nvim** — Shows function signature and parameter hints in a floating window while typing
- **goolord/alpha-nvim** — Customizable start screen/dashboard with shortcuts and recent files
- **junegunn/vim-easy-align** — (see Editing section above)

---

## Disabled / Commented Out

- **github/copilot.vim** — GitHub Copilot AI completions (disabled)
- **CopilotC-Nvim/CopilotChat.nvim** — Copilot chat interface (disabled)
- **zbirenbaum/copilot-cmp** — Copilot nvim-cmp source (disabled)
- **nvim-platformio/nvim-platformio.lua** — PlatformIO embedded development toolchain (disabled)
