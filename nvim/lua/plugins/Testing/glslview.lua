require('glslView').setup {
  exe = 'glslViewer',
  args = { '-l' },
}

vim.keymap.set('n', '<leader>tg', '<cmd>GlslView<cr>', { desc = 'GLSL: Open live preview' })
