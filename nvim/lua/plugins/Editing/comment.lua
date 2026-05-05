require('Comment').setup()

vim.keymap.set('n', '<C-_>', '<Plug>(comment_toggle_linewise_current)', { desc = 'Comment' })
vim.keymap.set('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Comment' })
