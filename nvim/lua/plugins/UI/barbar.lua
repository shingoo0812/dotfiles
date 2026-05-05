-- Mitigate LSP request cancel errors on buffer switch
vim.api.nvim_create_autocmd('BufLeave', {
  callback = function()
    vim.defer_fn(function() end, 10)
  end,
})

require('barbar').setup {
  animation = true,
  auto_hide = false,
  tabpages = true,
  icons = {
    buffer_index = false,
    buffer_number = false,
    button = '',
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
      [vim.diagnostic.severity.WARN] = { enabled = false },
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = true },
    },
    gitsigns = {
      added = { enabled = true, icon = '+' },
      changed = { enabled = true, icon = '~' },
      deleted = { enabled = true, icon = '-' },
    },
    filetype = { custom_colors = false, enabled = true },
    separator = { left = '▎', right = '' },
    separator_at_end = true,
    modified = { button = '●' },
    pinned = { button = '', filename = true },
    preset = 'default',
    alternate = { filetype = { enabled = false } },
    current = { buffer_index = true },
    inactive = { button = '×' },
    visible = { modified = { buffer_number = false } },
  },
  maximum_length = 30,
  minimum_length = 0,
}

vim.keymap.set('n', 'H', '<cmd>BufferPrevious<cr>')
vim.keymap.set('n', 'L', '<cmd>BufferNext<cr>')
vim.keymap.set('n', '<A-h>', '<cmd>BufferMovePrevious<cr>')
vim.keymap.set('n', '<A-l>', '<cmd>BufferMoveNext<cr>')
vim.keymap.set('n', '<A-1>', '<cmd>BufferGoto 1<cr>')
vim.keymap.set('n', '<A-2>', '<cmd>BufferGoto 2<cr>')
vim.keymap.set('n', '<A-3>', '<cmd>BufferGoto 3<cr>')
vim.keymap.set('n', '<A-4>', '<cmd>BufferGoto 4<cr>')
vim.keymap.set('n', '<A-5>', '<cmd>BufferGoto 5<cr>')
vim.keymap.set('n', '<A-6>', '<cmd>BufferGoto 6<cr>')
vim.keymap.set('n', '<A-7>', '<cmd>BufferGoto 7<cr>')
vim.keymap.set('n', '<A-8>', '<cmd>BufferGoto 8<cr>')
vim.keymap.set('n', '<A-9>', '<cmd>BufferGoto 9<cr>')
vim.keymap.set('n', '<C-p>', '<cmd>BufferPin<cr>')
vim.keymap.set('n', '<C-w>', '<Cmd>BufferClose<cr>')
vim.keymap.set('n', '<C-x>', '<Cmd>BufferRestore<cr>')
