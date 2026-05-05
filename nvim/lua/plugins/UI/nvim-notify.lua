local notify = require 'notify'

notify.setup {
  stages = 'fade',
  timeout = 3000,
  max_height = function() return math.floor(vim.o.lines * 0.75) end,
  max_width = function() return math.floor(vim.o.columns * 0.75) end,
  render = 'default',
  background_colour = '#000000',
}

vim.notify = function(msg, level, opts)
  opts = opts or {}
  if level == vim.log.levels.ERROR then
    opts.timeout = 10000
  end
  require 'notify'(msg, level, opts)
end

vim.keymap.set('n', '<leader>dn', function() require('notify').dismiss() end, { desc = 'Dismiss all notifications' })
vim.keymap.set('n', '<C-c>', function() require('notify').dismiss() end, { desc = 'Dismiss all notifications' })
vim.keymap.set('n', '<leader>sN', function()
  require('telescope').extensions.notify.notify()
end, { desc = 'Open notification history' })
