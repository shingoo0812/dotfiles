require('oil').setup {
  default_file_explorer = true,
  columns = { 'icon' },
  buf_options = { buflisted = false, bufhidden = 'hide' },
  win_options = {
    wrap = false,
    signcolumn = 'no',
    cursorcolumn = false,
    foldcolumn = '0',
    spell = false,
    list = false,
    conceallevel = 0,
    concealcursor = 'nvic',
  },
  delete_to_trash = false,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = true,
  view_options = { show_hidden = true },
  float = { padding = 2, max_width = 90, max_height = 30, border = 'rounded', win_options = { winblend = 0 } },
  preview = {
    max_width = 0.9, min_width = { 40, 0.4 }, max_height = 0.9, min_height = { 5, 0.1 },
    border = 'rounded', win_options = { winblend = 0 },
  },
  progress = {
    max_width = 0.9, min_width = { 40, 0.4 }, max_height = { 10, 0.9 }, min_height = { 5, 0.1 },
    border = 'rounded', minimized_border = 'none', win_options = { winblend = 0 },
  },
}

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '<leader>-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory in float' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'oil',
  callback = function()
    vim.keymap.set('n', '<C-p>', require('oil.actions').preview.callback, { buffer = true, desc = 'Preview file' })
    vim.keymap.set('n', '<C-r>', require('oil.actions').refresh.callback, { buffer = true, desc = 'Refresh' })
    vim.keymap.set('n', 'g?', require('oil.actions').show_help.callback, { buffer = true, desc = 'Show help' })
  end,
})
