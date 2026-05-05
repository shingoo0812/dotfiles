local M = {}
-----------------------------------------------------
-- Helper Functions
-----------------------------------------------------
local func = require 'config.functions'
local find_venv_root = func.functions.utils.find_venv_root

-- Virtual environment cache (FilePath → venv root mapping)
local venv_cache = {}

-- Currently active Pyright root
local current_pyright_root = nil

-- Timer for debouncing
local restart_timer = nil

-----------------------------------------------------
-- Autocmds Table
-----------------------------------------------------
M.autocmds = {
  {
    group = 'PyrightAutoSwitch',
    event = 'BufEnter',
    pattern = '*.py',
    callback = function()
      local current_buf = vim.api.nvim_get_current_buf()
      local current_file = vim.api.nvim_buf_get_name(current_buf)

      -- vim.notify('## BufEnter: ' .. current_file, vim.log.levels.DEBUG)

      -- Exclude special buffer types
      local buftype = vim.bo[current_buf].buftype
      if buftype ~= '' then
        return
      end

      -- Exclude if filename is empty
      if current_file == '' then
        return
      end

      -- Check if it's a Python file
      if vim.bo[current_buf].filetype ~= 'python' then
        return
      end

      -- Check if file actually exists
      if vim.fn.filereadable(current_file) ~= 1 then
        return
      end

      -- Check cache
      local cached_root = venv_cache[current_file]
      local new_root

      if cached_root then
        -- Cache hit
        new_root = cached_root
        -- vim.notify('Cache hit: ' .. new_root, vim.log.levels.DEBUG)
      else
        -- Cache miss, new search
        new_root = find_venv_root(current_file)
        if new_root then
          -- Save to cache
          venv_cache[current_file] = new_root
          -- vim.notify('Cache miss, found: ' .. new_root, vim.log.levels.DEBUG)
        end
      end

      if not new_root then
        return
      end

      -- Skip if same as current Pyright root
      if current_pyright_root == new_root then
        -- vim.notify('Skipping: same venv root as current Pyright', vim.log.levels.DEBUG)
        return
      end

      local clients = vim.lsp.get_clients { bufnr = current_buf, name = 'pyright' }

      -- Launch if no client exists
      if #clients == 0 then
        vim.notify('Starting Pyright with root: ' .. new_root, vim.log.levels.INFO)
        current_pyright_root = new_root
        vim.cmd 'LspStart pyright'
        return
      end

      -- Check if any client has a different root
      local needs_restart = false
      for _, client in ipairs(clients) do
        local current_root = client.config.root_dir
        if current_root ~= new_root then
          needs_restart = true
          break
        end
      end

      if not needs_restart then
        -- vim.notify('No need to restart Pyright, root unchanged', vim.log.levels.DEBUG)
        return
      end

      -- Cancel existing timer (debounce consecutive BufEnter)
      if restart_timer then
        vim.fn.timer_stop(restart_timer)
      end

      -- Notification
      vim.notify('Pyright: Switching to ' .. new_root, vim.log.levels.INFO)

      -- Stop all Pyright clients
      for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id, true)
      end

      -- Wait a bit before restarting
      restart_timer = vim.fn.timer_start(500, function()
        -- Restart with new root
        vim.cmd 'LspStart pyright'
        -- Update current root
        current_pyright_root = new_root
        restart_timer = nil
      end)
    end,
    desc = 'Auto-switch Pyright root directory based on project .venv',
  },

  {
    -- Highlight yanked text
    group = 'kickstart-highlight-yank',
    event = 'TextYankPost', -- Trigger after yanking text
    pattern = '*', -- Match all buffers
    callback = function()
      vim.hl.on_yank() -- Built-in function to flash yanked text
    end,
    desc = 'Highlight when yanking (copying) text',
  },

  {
    -- Automatically redraw the screen when entering a window or resizing
    group = 'RedrawOnWindowChange',
    event = { 'WinEnter', 'BufEnter', 'VimResized' }, -- Multiple events
    pattern = '*', -- Match all buffers
    callback = function()
      vim.cmd 'redraw' -- Redraw screen
    end,
    desc = 'Automatically redraw when window is entered or resized',
  },
  {
    group = 'FixObsidianMarkdownFiletype',
    event = { 'BufEnter' },
    pattern = '*',
    callback = function(args)
      local buf = args.buf
      local name = vim.api.nvim_buf_get_name(buf)

      -- Correct only if filetype is empty even though it is a .md file
      if name:match '%.md$' and vim.bo[buf].filetype == '' then
        vim.bo[buf].filetype = 'markdown'
      end
    end,
    desc = 'Fix missing filetype for Obsidian markdown buffers',
  },
  -- GDScript filetype detection
  {
    group = 'GDScriptFiletype',
    event = { 'BufRead', 'BufNewFile' },
    pattern = { '*.gd', '*.gdscript', '*.gdscript3' },
    desc = 'Set filetype to gdscript for GDScript files',
    callback = function()
      vim.bo.filetype = 'gdscript'
    end,
  },
  -- You can add more autocmds here following the same format
  -- Theme highlight overrides
  {
    group = 'ThemeHighlightOverrides',
    event = 'ColorScheme',
    pattern = '*',
    callback = function()
      vim.api.nvim_set_hl(0, '@variable', { fg = '#c0caf5' })
      vim.api.nvim_set_hl(0, '@variable.member', { fg = '#dcdcaa' })
      vim.api.nvim_set_hl(0, '@function.call', { fg = '#dcdcaa' })
      vim.api.nvim_set_hl(0, 'TSFunctionCall', { fg = '#dcdcaa' })
      vim.cmd.hi 'GreenBold guifg=#dcdcaa'
      vim.api.nvim_set_hl(0, '@comment', { fg = '#7aa2f7' })
      vim.api.nvim_set_hl(0, '@lsp.type.member.javascriptreact', { fg = '#dcdcaa' })
      vim.api.nvim_set_hl(0, '@function.method.call.javascript', { fg = '#dcdcaa' })
    end,
  },
}

-----------------------------------------------------
-- Register autocmds
-----------------------------------------------------
for _, autocmd in ipairs(M.autocmds) do
  local group = autocmd.group and vim.api.nvim_create_augroup(autocmd.group, { clear = true }) or nil
  vim.api.nvim_create_autocmd(autocmd.event, {
    group = group,
    pattern = autocmd.pattern,
    callback = autocmd.callback,
    desc = autocmd.desc,
  })
end

return M
