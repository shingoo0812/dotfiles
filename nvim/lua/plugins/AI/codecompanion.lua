vim.keymap.set({ 'n', 'v' }, '<leader>ca', ':CodeCompanionActions<CR>', { desc = 'CodeCompanion actions' })
vim.keymap.set({ 'n', 'v' }, '<leader>cc', ':CodeCompanionChat<CR>', { desc = 'CodeCompanion chat' })
vim.keymap.set('v', '<leader>ci', ':CodeCompanion<CR>', { desc = 'CodeCompanion inline edit' })
vim.keymap.set('n', '<leader>ce', ':CodeCompanionChat @{editor}<CR>', { desc = 'CodeCompanion chat with editor tools' })

require('codecompanion').setup {
  strategies = {
    chat = {
      adapter = 'ollama_chat',
    },
    inline = {
      adapter = 'ollama_inline',
    },
  },
  adapters = {
    http = {
      ollama_chat = function()
        return require('codecompanion.adapters').extend('ollama', {
          name = 'ollama_chat',
          schema = { model = { default = 'llama3.2:latest' } },
        })
      end,
      ollama_inline = function()
        return require('codecompanion.adapters').extend('ollama', {
          name = 'ollama_inline',
          schema = { model = { default = 'qwen2.5-coder:latest' } },
        })
      end,
    },
  },
  extensions = {
    mcphub = {
      callback = 'mcphub.extensions.codecompanion',
      opts = { show_result_in_chat = true },
    },
  },
}
