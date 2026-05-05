local harpoon = require 'harpoon'
harpoon:setup()

local keymap = vim.keymap.set

keymap('n', '<leader>ha', function()
  harpoon:list():add()
  vim.notify('Added to Harpoon: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
end, { desc = 'Add file to Harpoon' })

keymap('n', 'ha', function()
  harpoon:list():add()
  vim.notify('Added to Harpoon: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
end, { desc = 'Add file to Harpoon' })

keymap('n', '<leader>hd', function()
  local input = vim.fn.input 'Enter Harpoon index to remove: '
  local idx = tonumber(input)
  if idx then
    require('harpoon'):list():remove_at(idx)
    vim.notify('Removed Harpoon index: ' .. idx, vim.log.levels.INFO)
  else
    vim.notify('Invalid index.', vim.log.levels.ERROR)
  end
end, { desc = 'Remove Harpoon by index' })

keymap('n', '<leader>h', function() end, { desc = 'Harpoon' })

keymap('n', '<leader>hl', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
  vim.schedule(function()
    local buf = vim.api.nvim_get_current_buf()
    vim.keymap.set('n', '<C-j>', 'j', { buffer = buf, silent = true })
    vim.keymap.set('n', '<C-k>', 'k', { buffer = buf, silent = true })
  end)
end, { desc = 'Toggle Harpoon menu' })

keymap('n', '<leader>hh1', function() harpoon:list():select(1) end, { desc = 'Jump to Harpoon mark 1' })
keymap('n', '<leader>hh2', function() harpoon:list():select(2) end, { desc = 'Jump to Harpoon mark 2' })
keymap('n', '<leader>hh3', function() harpoon:list():select(3) end, { desc = 'Jump to Harpoon mark 3' })
keymap('n', '<leader>hh4', function() harpoon:list():select(4) end, { desc = 'Jump to Harpoon mark 4' })

local function set_mark(idx)
  local list = harpoon:list()
  local current_file = vim.api.nvim_buf_get_name(0)
  list:replace_at(idx, list.config.create_list_item(list.config, current_file))
  vim.notify('Set Harpoon mark ' .. idx .. ': ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
end

keymap('n', '<leader>h1', function() set_mark(1) end, { desc = 'Set Harpoon mark 1' })
keymap('n', '<leader>h2', function() set_mark(2) end, { desc = 'Set Harpoon mark 2' })
keymap('n', '<leader>h3', function() set_mark(3) end, { desc = 'Set Harpoon mark 3' })
keymap('n', '<leader>h4', function() set_mark(4) end, { desc = 'Set Harpoon mark 4' })
keymap('n', '<leader>h5', function() set_mark(5) end, { desc = 'Set Harpoon mark 5' })
keymap('n', '<leader>h6', function() set_mark(6) end, { desc = 'Set Harpoon mark 6' })

keymap('n', '<A-h>', function() harpoon:list():prev() end, { desc = 'Harpoon: Previous mark' })
keymap('n', '<A-l>', function() harpoon:list():next() end, { desc = 'Harpoon: Next mark' })
