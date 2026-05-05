require('gen').setup {
  model = 'qwen2.5-coder:7b',
  host = 'localhost',
  port = '11434',
  display_mode = 'float',
}

vim.keymap.set('n', '<leader>o', ':Gen<CR>', { desc = 'Generate with Ollama / gen.nvim' })
