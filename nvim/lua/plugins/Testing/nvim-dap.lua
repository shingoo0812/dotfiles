local func = require 'config.functions'
local detect_os = func.functions.utils.detect_os

local dap = require 'dap'
local dapui = require 'dapui'
local dap_python = require 'dap-python'

require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = { 'debugpy' },
}

vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F8>', dap.terminate, { desc = 'Debug: Terminate' })

vim.keymap.set('n', '<leader>d', '', { desc = 'Debug' })
vim.keymap.set('n', '<leader>d1', dap.continue, { desc = 'Debug: Start/Continue(F5)' })
vim.keymap.set('n', '<leader>d2', dap.step_into, { desc = 'Debug: Step Into(F1)' })
vim.keymap.set('n', '<leader>d3', dap.step_over, { desc = 'Debug: Step Over(F2)' })
vim.keymap.set('n', '<leader>d4', dap.step_out, { desc = 'Debug: Step Out(F3)' })
vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>du', '<cmd>lua require("dapui").toggle()<cr>', { desc = 'Toggle Dap UI' })
vim.keymap.set('n', '<leader>dc', '<cmd>lua require("dapui").close()<cr>', { desc = 'Close Dap UI' })
vim.keymap.set('n', '<leader>de', ':DapTerminate<cr>', { desc = 'DAP End' })
vim.keymap.set('n', '<leader>db', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<leader>ds', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<leader>dpm', dap_python.test_method, { desc = 'Debug: Python Test Method' })
vim.keymap.set('n', '<leader>dpc', dap_python.test_class, { desc = 'Debug: Python Test Class' })
vim.keymap.set('v', '<leader>dps', dap_python.debug_selection, { desc = 'Debug: Python Selection' })
vim.keymap.set('n', '<leader>dr', '<cmd>lua require("dapui").float_element("repl", { enter = true })<cr>', { desc = 'Debug: Open REPL' })
vim.keymap.set('n', '<leader>do', '<cmd>lua require("dapui").float_element("console", { enter = true })<cr>', { desc = 'Debug: Open Console' })
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸', play = '▶', step_into = '⏎', step_over = '⏭',
      step_out = '⏮', step_back = 'b', run_last = '▶▶', terminate = '⏹', disconnect = '⏏',
    },
  },
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 0.25 },
        { id = 'breakpoints', size = 0.25 },
        { id = 'stacks', size = 0.25 },
        { id = 'watches', size = 0.25 },
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        { id = 'repl', size = 0.5 },
        { id = 'console', size = 0.5 },
      },
      size = 10,
      position = 'bottom',
    },
  },
  mappings = {
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
}

dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

dap.listeners.after['event_output']['dapui_output'] = function(_, body)
  if body.category == 'stdout' or body.category == 'console' then
    vim.schedule(function()
      require('dap.repl').append(body.output)
    end)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-repl',
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, silent = true })
  end,
})

-- Python debug setup
local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv'

local function get_project_python()
  local cwd = vim.fn.getcwd()
  local paths = {
    cwd .. '\\.qtcreator\\Python_3_13_7venv\\Scripts\\python.exe',
    cwd .. '\\.venv\\Scripts\\python.exe',
    cwd .. '/.venv/bin/python',
    cwd .. '\\venv\\Scripts\\python.exe',
    cwd .. '/venv/bin/python',
  }
  for _, path in ipairs(paths) do
    if vim.fn.executable(path) == 1 then return path end
  end
  return nil
end

local project_python = get_project_python()
if project_python and dap.configurations.python then
  for _, config in pairs(dap.configurations.python) do
    config.pythonPath = project_python
    config.console = 'integratedTerminal'
  end
end

table.insert(dap.configurations.python or {}, {
  type = 'python',
  request = 'launch',
  name = 'Launch FastAPI',
  program = '${workspaceFolder}/main.py',
  pythonPath = project_python,
  args = {},
  console = 'integratedTerminal',
})

dap.adapters.godot = {
  type = 'server',
  host = '127.0.0.1',
  port = 6006,
}

dap.configurations.gdscript = {
  {
    type = 'godot',
    request = 'launch',
    name = 'Launch Project (Use Project Settings)',
    project = '${workspaceFolder}',
    launch_game_instance = true,
    launch_scene = false,
  },
  {
    type = 'godot',
    request = 'launch',
    name = 'Launch Current Scene',
    project = '${workspaceFolder}',
    launch_game_instance = true,
    launch_scene = true,
    scene = '${file}',
  },
  {
    type = 'godot',
    request = 'launch',
    name = 'Attach to Running Game',
    project = '${workspaceFolder}',
    launch_game_instance = false,
  },
}

require('dap-go').setup {
  delve = {
    detached = detect_os ~= 'windows',
  },
}
