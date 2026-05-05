----------------------------------
-- General Neovim settings
----------------------------------

-- Set <Space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[Settings for UFO]]
vim.o.foldenable = true -- Disable folding
vim.o.foldlevel = 99 -- Set to fully expanded state
vim.o.foldlevelstart = 99 -- Fully expanded on startup too
vim.o.foldmethod = 'expr' -- Folding with expr
vim.o.foldexpr = "v:lua.require('ufo').foldexpr()" -- Use UFO's foldexpr
vim.o.foldcolumn = '1' -- Show fold column on the left
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- Line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = '>>> '
-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
-- Don't treat markdown files outside Vimwiki directory as vimwiki
vim.g.vimwiki_global_ext = 0

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Configure session options for auto-session
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.env.PYTHONIOENCODING = 'utf-8'

-- Autoindent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.cmd 'filetype plugin indent on'

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

-- Fix rendering for Windows Terminal
vim.opt.termguicolors = true
vim.opt.lazyredraw = false

-- Allow hiding unsaved buffers (no errors when switching buffers)
vim.opt.hidden = true
-- Auto-reload files modified externally
vim.opt.autoread = true
-- Option: Auto-save when switching buffers
vim.opt.autowrite = true
