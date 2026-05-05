require('kulala').setup {
  global_keymaps = false,
  global_keymaps_prefix = '<leader>R',
  kulala_keymaps_prefix = '',
}

vim.keymap.set('n', '<leader>R', function() end, { desc = 'REST Client' })
vim.keymap.set('n', '<leader>Rs', '<cmd>lua require("kulala").run()<cr>', { desc = 'Send request' })
vim.keymap.set('n', '<leader>Ra', '<cmd>lua require("kulala").run_all()<cr>', { desc = 'Send all requests' })
vim.keymap.set('n', '<leader>Rb', '<cmd>lua require("kulala").scratchpad()<cr>', { desc = 'Open scratchpad' })
