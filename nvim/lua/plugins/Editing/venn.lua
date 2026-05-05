function ToggleVenn()
  if vim.b.venn_enabled then
    vim.b.venn_enabled = false
    vim.cmd 'setlocal ve='
    vim.cmd 'mapclear <buffer>'
  else
    vim.b.venn_enabled = true
    vim.cmd 'setlocal ve=all'
    vim.keymap.set('n', 'J', '<C-v>j:VBox<CR>', { buffer = true })
    vim.keymap.set('n', 'K', '<C-v>k:VBox<CR>', { buffer = true })
    vim.keymap.set('n', 'L', '<C-v>l:VBox<CR>', { buffer = true })
    vim.keymap.set('n', 'H', '<C-v>h:VBox<CR>', { buffer = true })
    vim.keymap.set('v', 'V', ':VBox<CR>', { buffer = true })
  end
end

vim.keymap.set('n', '<leader>v', function() ToggleVenn() end, { desc = 'Toggle Venn Mode' })
