-- Simple Windows clipboard via PowerShell
vim.opt.clipboard = 'unnamedplus'

vim.g.clipboard = {
  name = 'PowerShellClipboard',
  copy = {
    ['+'] = 'powershell.exe -NoProfile -Command Set-Clipboard -Value $input',
    ['*'] = 'powershell.exe -NoProfile -Command Set-Clipboard -Value $input',
  },
  paste = {
    ['+'] = 'powershell.exe -NoProfile -Command Get-Clipboard',
    ['*'] = 'powershell.exe -NoProfile -Command Get-Clipboard',
  },
  cache_enabled = 0,
}
