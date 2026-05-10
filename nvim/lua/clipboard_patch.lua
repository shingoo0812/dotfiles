if vim.fn.has('wsl') == 1 then
    vim.g.clipboard = {
        name          = 'WslClipboard',
        copy          = { ['+'] = 'clip.exe', ['*'] = 'clip.exe' },
        paste         = {
            ['+'] = { 'powershell.exe', '-NoProfile', '-Command', 'Get-Clipboard' },
            ['*'] = { 'powershell.exe', '-NoProfile', '-Command', 'Get-Clipboard' },
        },
        cache_enabled = false,
    }
    vim.g.python3_host_prog = vim.fn.expand('~/.venv/nvim/bin/python3')
    vim.env.PATH = vim.env.PATH .. ':' .. vim.fn.expand('~/.dotnet') .. ':' .. vim.fn.expand('~/.dotnet/tools')
else
    local function my_paste(_)
        return function(_) return vim.split(vim.fn.getreg('"'), '\n') end
    end
    vim.g.clipboard = {
        name  = 'OSC 52',
        copy  = { ['+'] = require('vim.ui.clipboard.osc52').copy('+'), ['*'] = require('vim.ui.clipboard.osc52').copy('*') },
        paste = { ['+'] = my_paste('+'), ['*'] = my_paste('*') },
    }
end
