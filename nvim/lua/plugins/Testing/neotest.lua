local is_windows = vim.loop.os_uname().version:match 'Windows'

local function find_project_root()
  local dir = vim.fn.getcwd()
  while dir do
    if vim.loop.fs_stat(dir .. '/.git') or vim.loop.fs_stat(dir .. '/pyproject.toml') then
      return dir
    end
    local parent = vim.fn.fnamemodify(dir, ':h')
    if parent == dir then break end
    dir = parent
  end
  return vim.fn.getcwd()
end

local function find_venv_python()
  local root = find_project_root()
  local candidates = is_windows
    and {
      root .. '/.venv/Scripts/python.exe',
      root .. '/venv/Scripts/python.exe',
      root .. '/env/Scripts/python.exe',
    }
    or {
      root .. '/.venv/bin/python',
      root .. '/venv/bin/python',
      root .. '/env/bin/python',
    }
  for _, path in ipairs(candidates) do
    if vim.loop.fs_stat(path) then return path end
  end
  return 'python'
end

require('neotest').setup {
  adapters = {
    require 'neotest-python' {
      dap = { justMyCode = false },
      args = { '--collect-only' },
      runner = 'pytest',
      python = find_venv_python(),
    },
    require 'neotest-jest' {
      jestCommand = 'npm test --',
      env = { CI = true },
    },
  },
}

vim.keymap.set('n', '<leader>t', function() end, { desc = 'Test and Translate' })
vim.keymap.set('n', '<leader>tn', function() require('neotest').run.run() end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, { desc = 'Run file tests' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end, { desc = 'Toggle Neotest summary' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output.open { enter = true } end, { desc = 'Open Neotest output' })
vim.keymap.set('n', '<leader>tp', function() vim.cmd('terminal pytest ' .. vim.fn.expand '%') end, { desc = 'Test with command pytest' })
