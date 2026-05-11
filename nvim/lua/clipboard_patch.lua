-- Windows clipboard via PowerShell
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
  -- Windows native: use PowerShell directly
  vim.g.clipboard = {
    name = 'WindowsPowerShell',
    copy = {
      ['+'] = { 'powershell.exe', '-NoProfile', '-Command', 'Set-Clipboard', '-Value', '$input' },
      ['*'] = { 'powershell.exe', '-NoProfile', '-Command', 'Set-Clipboard', '-Value', '$input' },
    },
    paste = {
      ['+'] = { 'powershell.exe', '-NoProfile', '-Command', 'Get-Clipboard' },
      ['*'] = { 'powershell.exe', '-NoProfile', '-Command', 'Get-Clipboard' },
    },
    cache_enabled = 0,
  }
end
