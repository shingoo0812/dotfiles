require('trouble').setup {}

vim.keymap.set('n', '<leader>x', '', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP (Trouble)' })
vim.keymap.set('n', '[d', function() end, { desc = 'Previous Diagnostic' })
vim.keymap.set('n', ']d', function() end, { desc = 'Next Diagnostic' })
