-- Simple Windows clipboard via PowerShell
vim.opt.clipboard = 'unnamedplus'

vim.g.clipboard = {
  name = 'win32yank',
  copy = {
    ['+'] = { 'C:\\Program Files\\Neovim\\bin\\win32yank.exe', '-i', '--crlf' },
    ['*'] = { 'C:\\Program Files\\Neovim\\bin\\win32yank.exe', '-i', '--crlf' },
  },
  paste = {
    ['+'] = { 'C:\\Program Files\\Neovim\\bin\\win32yank.exe', '-o', '--lf' },
    ['*'] = { 'C:\\Program Files\\Neovim\\bin\\win32yank.exe', '-o', '--lf' },
  },
  cache_enabled = false,
}
