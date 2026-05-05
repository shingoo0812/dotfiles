require('obsidian').setup {
  workspaces = {
    {
      name = 'notes',
      path = 'F:/Documents/ObsidianVault',
    },
  },
  daily_notes = {
    folder = 'daily',
    template = 'daily.md',
  },
  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },
  ui = { enable = true },
  note_id_func = function(title)
    return title:gsub(' ', '-'):lower()
  end,
}

vim.keymap.set('n', '<leader><leader>o', '', { desc = 'Obsidian' })
vim.keymap.set('n', '<leader><leader>oo', '<cmd>ObsidianOpen<CR>', { desc = 'Obsidian: Open note' })
vim.keymap.set('n', '<leader><leader>on', '<cmd>ObsidianNew<CR>', { desc = 'Obsidian: New note' })
vim.keymap.set('n', '<leader><leader>os', '<cmd>ObsidianSearch<CR>', { desc = 'Obsidian: Search notes' })
vim.keymap.set('n', '<leader><leader>ot', '<cmd>ObsidianToday<CR>', { desc = 'Obsidian: Today' })
vim.keymap.set('n', '<leader><leader>oy', '<cmd>ObsidianYesterday<CR>', { desc = 'Obsidian: Yesterday' })
vim.keymap.set('n', '<leader><leader>ol', '<cmd>ObsidianLinks<CR>', { desc = 'Obsidian: Links' })
vim.keymap.set('n', '<leader><leader>ob', '<cmd>ObsidianBacklinks<CR>', { desc = 'Obsidian: Backlinks' })
