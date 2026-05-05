-- Command to clear ShaDa temporary files
vim.api.nvim_create_user_command('ClearShada', function()
  local shada_dir = vim.fn.stdpath 'data' .. '/shada'

  -- Save current ShaDa
  vim.cmd 'wshada!'

  -- Delete temporary files
  local tmp_files = vim.fn.glob(shada_dir .. '/main.shada.tmp.*', false, true)
  local deleted = 0

  for _, file in ipairs(tmp_files) do
    local success = vim.fn.delete(file)
    if success == 0 then
      deleted = deleted + 1
    end
  end

  if deleted > 0 then
    vim.notify(string.format('Cleared %d ShaDa temporary file(s)', deleted), vim.log.levels.INFO)
    vim.cmd 'rshada!'
  else
    vim.notify('No ShaDa temporary files to clear', vim.log.levels.INFO)
  end
end, { desc = 'Clear ShaDa temporary files' })

-- Command to completely reset ShaDa
vim.api.nvim_create_user_command('ResetShada', function()
  local shada_dir = vim.fn.stdpath 'data' .. '/shada'
  local shada_file = shada_dir .. '/main.shada'
  local backup_file = shada_file .. '.bak'

  vim.fn.rename(shada_file, backup_file)

  local tmp_files = vim.fn.glob(shada_dir .. '/main.shada.tmp.*', false, true)
  for _, file in ipairs(tmp_files) do
    vim.fn.delete(file)
  end

  vim.notify('ShaDa reset! Backup saved to: ' .. backup_file, vim.log.levels.WARN)
  vim.notify('Restart Neovim to complete the reset', vim.log.levels.INFO)
end, { desc = 'Reset ShaDa file (creates backup)' })

-- Keymaps
vim.keymap.set('n', '<leader><leader>s', '', { desc = 'Shada' })
vim.keymap.set('n', '<leader><leader>sc', '<cmd>ClearShada<cr>', { desc = 'Clear ShaDa temp files' })
vim.keymap.set('n', '<leader><leader>sr', '<cmd>ResetShada<cr>', { desc = 'Reset ShaDa' })

-- Auto-delete temporary files on startup if they remain
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local shada_dir = vim.fn.stdpath 'data' .. '/shada'
    local tmp_files = vim.fn.glob(shada_dir .. '/main.shada.tmp.*', false, true)

    if #tmp_files > 0 then
      for _, file in ipairs(tmp_files) do
        vim.fn.delete(file)
      end
      vim.notify('Cleaned up ' .. #tmp_files .. ' stale ShaDa temp file(s)', vim.log.levels.INFO)
    end
  end,
})
