vim.cmd.packadd('otter.nvim')

require('otter').setup {
  lsp = {
    hover = { border = 'rounded' },
    root_dir = function()
      return vim.fn.getcwd()
    end,
  },
  buffers = {
    set_filetype = true,
  },
}

-- Auto-activate otter in markdown and quarto files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'quarto' },
  callback = function()
    require('otter').activate()
  end,
})

vim.keymap.set('n', '<leader>jO', function()
  require('otter').activate()
end, { desc = 'Otter: activate LSP in code blocks' })
