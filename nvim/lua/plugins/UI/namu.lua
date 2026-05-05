require('namu').setup {
  global = {},
  namu_symbols = { options = {} },
}

vim.keymap.set('n', '<leader>n', '', { desc = 'Namu' })
vim.keymap.set('n', '<leader>ns', '<cmd>Namu symbols<cr>', { desc = 'Namu Symbols' })
vim.keymap.set('n', '<leader>nw', '<cmd>Namu workspace<cr>', { desc = 'Namu Workspace' })
