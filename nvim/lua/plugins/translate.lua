require('translate').setup {
  default = {
    command = 'google',
    output = 'replace',
  },
}

vim.keymap.set('n', '<leader><leader>tj', ':Translate ja<CR>', { desc = 'Replace to Japanese' })
vim.keymap.set('n', '<leader><leader>te', ':Translate en<CR>', { desc = 'Replace to English' })
vim.keymap.set('v', '<leader><leader>tre', function() vim.cmd 'Translate en' end, { desc = 'Replace to English' })
vim.keymap.set('v', '<leader><leader>trj', function() vim.cmd 'Translate ja' end, { desc = 'Replace to Japanese' })
