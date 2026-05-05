vim.keymap.set('n', '<leader>g', '', { desc = 'Git & Glance' })
vim.keymap.set('n', '<leader>gg', function()
  local util = require 'lspconfig.util'
  local bufpath = vim.api.nvim_buf_get_name(0)
  local root = util.root_pattern '.git'(bufpath)
  if not root or root == '' then
    root = vim.fn.getcwd()
  end
  require('lazygit').lazygit(root)
end, { desc = 'LazyGit (Open at Project Root)' })
