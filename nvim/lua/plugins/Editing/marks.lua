local marks = require 'marks'

marks.setup {
  default_mappings = false,
  cyclic = true,
  force_write_shada = true,
}

local keymap = vim.keymap.set
keymap('n', '`a', '`a', { desc = 'Jump to exact position of mark a' })
keymap('n', '`b', '`b', { desc = 'Jump to exact position of mark b' })
keymap('n', '`c', '`c', { desc = 'Jump to exact position of mark c' })
keymap('n', '`d', '`d', { desc = 'Jump to exact position of mark d' })
