-- Note: strudel.nvim requires 'npm ci' build step — run manually after install
require('strudel').setup {
  start_on_launch = true,
  sync_cursor = true,
  report_eval_errors = true,
  update_on_save = true,
}

vim.keymap.set('n', '<leader><leader>S', '', { desc = 'Strudel' })
vim.keymap.set('n', '<leader><leader>Sl', '<cmd>StrudelLaunch<cr>', { desc = 'Launch Strudel' })
vim.keymap.set('n', '<leader><leader>Sq', '<cmd>StrudelQuit<cr>', { desc = 'Quit Strudel' })
vim.keymap.set('n', '<leader><leader>St', '<cmd>StrudelToggle<cr>', { desc = 'Toggle Strudel' })
vim.keymap.set('n', '<leader><leader>Su', '<cmd>StrudelUpdate<cr>', { desc = 'Update Strudel' })
vim.keymap.set('n', '<leader><leader>Ss', '<cmd>StrudelStop<cr>', { desc = 'Stop Strudel' })
vim.keymap.set('n', '<leader><leader>Sb', '<cmd>StrudelSetBuffer<cr>', { desc = 'Set Buffer Strudel' })
vim.keymap.set('n', '<leader><leader>Se', '<cmd>StrudelExecute<cr>', { desc = 'Execute Strudel' })
