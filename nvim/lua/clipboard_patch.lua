vim.opt.clipboard = 'unnamedplus'
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = { ['+'] = 'clip.exe', ['*'] = 'clip.exe' },
    paste = {
      ['+'] = { 'powershell.exe', '-NoProfile', '-Command', 'Get-Clipboard' },
      ['*'] = { 'powershell.exe', '-NoProfile', '-Command', 'Get-Clipboard' },
    },
    cache_enabled = false,
  }
else
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
end
