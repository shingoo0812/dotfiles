-- Windows clipboard via win32yank (handles CRLF properly)
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
  -- Windows native: use win32yank for proper CRLF handling
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = { 'C:\\Users\\shing\\scoop\\shims\\win32yank.exe', '-i', '--crlf' },
      ['*'] = { 'C:\\Users\\shing\\scoop\\shims\\win32yank.exe', '-i', '--crlf' },
    },
    paste = {
      ['+'] = { 'C:\\Users\\shing\\scoop\\shims\\win32yank.exe', '-o', '--lf' },
      ['*'] = { 'C:\\Users\\shing\\scoop\\shims\\win32yank.exe', '-o', '--lf' },
    },
    cache_enabled = false,
  }
end
