require('zen-mode').setup {
  window = {
    width = 0.8,
    height = 1,
    options = {
      number = true,
      relativenumber = false,
      cursorline = true,
      foldcolumn = '0',
      signcolumn = 'no',
    },
  },
  plugins = {
    options = { ruler = false, showcmd = false },
    gitsigns = { enabled = true },
    tmux = false,
    twilight = { enabled = true },
  },
  on_open = function() print 'Zen mode activated!' end,
  on_close = function() print 'Zen mode closed!' end,
}
