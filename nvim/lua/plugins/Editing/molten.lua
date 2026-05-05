-- Note: molten-nvim requires ':UpdateRemotePlugins' build step — run manually after install
vim.g.molten_image_provider = 'none'
vim.g.molten_output_win_max_height = 20
vim.g.molten_auto_open_output = false
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.ipynb',
  callback = function()
    vim.bo.filetype = 'python'
    vim.schedule(function()
      vim.cmd 'MoltenInit python3'
    end)
  end,
})

vim.keymap.set('n', '<leader>j', '', { desc = 'Molten(JupyterNotebook)' })
vim.keymap.set('n', '<leader>ji', ':MoltenInit<CR>', { desc = 'Initialize Molten' })
vim.keymap.set('n', '<leader>jl', ':MoltenEvaluateLine<CR>', { desc = 'Evaluate Line' })
vim.keymap.set('n', '<leader>jr', ':MoltenReevaluateCell<CR>', { desc = 'Re-evaluate Cell' })
vim.keymap.set('v', '<leader>jv', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'Evaluate Visual' })
vim.keymap.set('n', '<leader>jd', ':MoltenDelete<CR>', { desc = 'Delete Cell' })
vim.keymap.set('n', '<leader>jo', ':MoltenHideOutput<CR>', { desc = 'Hide Output' })
vim.keymap.set('n', '<leader>js', ':noautocmd MoltenEnterOutput<CR>', { desc = 'Show Output' })
