require('flash').setup {
  labels = 'asdfghjklqwertyuiopzxcvbnm',
  search = {
    multi_window = true,
    forward = true,
    wrap = true,
  },
  jump = {
    jumplist = true,
    pos = 'start',
    history = false,
    register = false,
    nohlsearch = true,
    autojump = false,
  },
  label = {
    uppercase = true,
    rainbow = {
      enabled = false,
      shade = 5,
    },
  },
  modes = {
    char = {
      enabled = true,
      keys = { 'f', 'F', 't', 'T' },
      jump_labels = true,
    },
  },
}

vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash Jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').jump {
    search = { mode = 'search', max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = '^',
  }
end, { desc = 'Flash Line' })
