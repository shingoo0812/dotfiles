require('spelunk').setup {
  {
    window_mappings = {
      cursor_down = 'j',
      cursor_up = 'k',
      bookmark_down = '<C-j>',
      bookmark_up = '<C-k>',
      goto_bookmark = '<CR>',
      goto_bookmark_hsplit = 'x',
      goto_bookmark_vsplit = 'v',
      change_line = 'l',
      delete_bookmark = 'd',
      next_stack = '<Tab>',
      previous_stack = '<S-Tab>',
      new_stack = 'n',
      delete_stack = 'D',
      edit_stack = 'E',
      close = 'q',
      help = 'h',
    },
    enable_persist = false,
    statusline_prefix = '🔖',
    orientation = 'vertical',
    enable_status_col_display = false,
    cursor_character = '>',
    persist_by_git_branch = false,
    fuzzy_search_provider = 'native',
  },
}

vim.keymap.set('n', '<leader>b', '', { desc = 'Spelunk Bookmark' })
vim.keymap.set('n', '<leader>bt', '<cmd>SpelunkToggle<cr>', { desc = 'Toggle Spelunk UI' })
vim.keymap.set('n', '<leader>ba', '<cmd>SpelunkAddBookmark<cr>', { desc = 'Add Bookmark' })
vim.keymap.set('n', '<leader>bd', '<cmd>SpelunkDeleteBookmark<cr>', { desc = 'Delete Bookmark' })
vim.keymap.set('n', '<leader>bn', '<cmd>SpelunkNextBookmark<cr>', { desc = 'Next Bookmark' })
vim.keymap.set('n', '<leader>bp', '<cmd>SpelunkPrevBookmark<cr>', { desc = 'Previous Bookmark' })
vim.keymap.set('n', '<leader>bf', '<cmd>SpelunkSearchBookmarks<cr>', { desc = 'Search Bookmarks' })
vim.keymap.set('n', '<leader>bc', '<cmd>SpelunkSearchCurrentBookmarks<cr>', { desc = 'Search Current Bookmarks' })
vim.keymap.set('n', '<leader>bs', '<cmd>SpelunkSearchStacks<cr>', { desc = 'Search Stacks' })
vim.keymap.set('n', '<leader>bl', '<cmd>SpelunkChangeLine<cr>', { desc = 'Change Line of Bookmark' })
