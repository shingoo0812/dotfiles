require('persistence').setup {
  dir = vim.fn.stdpath 'state' .. '/sessions/',
  options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
}

vim.keymap.set('n', '<leader>S', function() end, { desc = 'Session Management' })
vim.keymap.set('n', '<leader>Ss', function() require('persistence').load() end, { desc = 'Restore Session' })
vim.keymap.set('n', '<leader>Sl', function() require('persistence').load { last = true } end, { desc = 'Restore Last Session' })
vim.keymap.set('n', '<leader>Sd', function() require('persistence').stop() end, { desc = 'Dont Save Current Session' })
