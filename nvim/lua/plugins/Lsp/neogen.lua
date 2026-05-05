require('neogen').setup {
  enabled = true,
  languages = {
    python = {
      template = {
        annotation_convention = 'google_docstrings',
      },
    },
  },
}

vim.keymap.set('n', '<Leader>dd', '<cmd>Neogen<cr>', { desc = 'Generate docs' })
