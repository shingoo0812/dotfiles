require('markview').setup {
  modes = { 'n', 'no', 'c' },
  hybrid_modes = { 'i' },
  filetypes = { 'markdown', 'vimwiki' },
  buf_ignore = {},
}

vim.api.nvim_set_hl(0, 'MarkviewCode', { bg = '#2e3440' })
vim.api.nvim_set_hl(0, 'MarkviewInlineCode', { bg = '#3b4252', fg = '#88c0d0' })
vim.api.nvim_set_hl(0, 'MarkviewLink', { fg = '#89b4fa', underline = true })
vim.api.nvim_set_hl(0, 'VimwikiLink', { fg = '#89b4fa', bold = true })
vim.api.nvim_set_hl(0, 'VimwikiLinkChar', { fg = '#6c7086' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'vimwiki' },
  callback = function()
    vim.wo.conceallevel = 2
    vim.wo.concealcursor = 'nc'
    vim.defer_fn(function()
      vim.cmd 'Markview enableAll'
    end, 100)
  end,
})
