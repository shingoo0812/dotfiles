-- Load nvim-treesitter plugin
vim.cmd.packadd('nvim-treesitter')
vim.cmd.packadd('nvim-treesitter-context')

-- Setup nvim-treesitter (new API for nvim-treesitter 1.0+)
vim.defer_fn(function()
  local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')
  if not ok then
    vim.notify('nvim-treesitter failed to load', vim.log.levels.ERROR)
    return
  end

  -- Setup with default config
  nvim_treesitter.setup {
    install_dir = vim.fn.stdpath('data') .. '/site'
  }

  -- Install parsers asynchronously
  nvim_treesitter.install {
    'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown',
    'markdown_inline', 'query', 'vim', 'vimdoc', 'python',
    'typescript', 'go', 'cpp', 'c_sharp', 'rust', 'javascript',
    'yaml',
  }

  -- Enable treesitter highlighting for all filetypes
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })

  -- Setup treesitter-context if available
  local ok2, treesitter_context = pcall(require, 'treesitter-context')
  if ok2 then
    treesitter_context.setup {
      enable = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = nil,
    }
  end
end, 100)
