require('oklch-color-picker').setup {}

vim.keymap.set('n', '<leader>cp', function()
  require('oklch-color-picker').pick_under_cursor()
end, { desc = 'Pick color' })
