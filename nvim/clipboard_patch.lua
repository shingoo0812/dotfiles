-- Clipboard: OSC52 copy, register fallback paste
-- To paste from host: use WezTerm right-click or Ctrl+Shift+V in insert mode
local function my_paste(_)
  return function(_)
    return vim.split(vim.fn.getreg('"'), '\n')
  end
end
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = my_paste('+'),
    ['*'] = my_paste('*'),
  },
}
