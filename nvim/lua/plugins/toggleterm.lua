require('toggleterm').setup {
  start_in_insert = true,
  shade_terminals = true,
  shell = vim.fn.has 'win32' == 1 and 'pwsh' or 'zsh',
  open_mapping = false,
}

vim.keymap.set('n', '<leader>1', '', { desc = 'Terminal' })
vim.keymap.set('n', '<leader>1h', '<cmd>ToggleTerm direction=horizontal size=10<cr>', { desc = 'Horizontal ToggleTerm' })
vim.keymap.set('n', '<leader>1v', '<cmd>ToggleTerm direction=vertical size=80<cr>', { desc = 'Vertical ToggleTerm' })
