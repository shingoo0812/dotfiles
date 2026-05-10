-- Clipboard configuration: WSL2 uses clip.exe, others use OSC52
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy  = { ['+'] = 'clip.exe', ['*'] = 'clip.exe' },
    paste = {
      ['+'] = { 'powershell.exe', '-NoProfile', '-Command', 'Get-Clipboard' },
      ['*'] = { 'powershell.exe', '-NoProfile', '-Command', 'Get-Clipboard' },
    },
    cache_enabled = false,
  }
else
  local function my_paste(_)
    return function(_)
      return vim.split(vim.fn.getreg('"'), '\n')
    end
  end
  vim.g.clipboard = {
    name = 'OSC 52',
    copy  = { ['+'] = require('vim.ui.clipboard.osc52').copy('+'), ['*'] = require('vim.ui.clipboard.osc52').copy('*') },
    paste = { ['+'] = my_paste('+'), ['*'] = my_paste('*') },
  }
end
