require('snacks').setup {
  -- Enable only what's needed; other plugins (claudecode, neo-tree) use snacks as a UI provider
  lazygit = { enabled = true },
  terminal = { enabled = true },
  toggle = { enabled = true },
  notifier = { enabled = false }, -- using nvim-notify instead
  dashboard = { enabled = false },
  explorer = { enabled = false },
  picker = { enabled = false },   -- using telescope instead
  bigfile = { enabled = false },
  image = { enabled = false },
  input = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
}
