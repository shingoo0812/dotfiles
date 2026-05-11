return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  config = function()
    require('Comment').setup()
    
    -- Ctrl+/ mapping (Ctrl+/ sends <C-_> in terminals)
    vim.keymap.set('n', '<C-_>', '<Plug>(comment_toggle_linewise_current)')
    vim.keymap.set('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)')
    
    -- Also try C-/ directly for some terminals
    vim.keymap.set('n', '<C-/>', '<Plug>(comment_toggle_linewise_current)')
    vim.keymap.set('v', '<C-/>', '<Plug>(comment_toggle_linewise_visual)')
  end,
}
