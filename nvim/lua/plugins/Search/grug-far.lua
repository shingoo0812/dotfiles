local fn = require 'config.functions'
local project_root = fn.functions.utils.get_project_root
local os_type = fn.functions.utils.detect_os()

local sg_path = 'sg'

if os_type == 'windows' then
  sg_path = 'C:/Users/shing/AppData/Roaming/npm/ast-grep.cmd'
elseif os_type == 'linux' then
  sg_path = 'sg'
end

-- 1. Setup grug-far
require('grug-far').setup {
  windowCreationCommand = 'vsplit',
  minSearchChars = 2,
  debounceMs = 500,
  disableActionConfirmation = true,
  staticTitle = 'Grug-far',
  -- Configure engines for structural search
  engines = {
    astgrep = {
      path = sg_path,
    },
  },
}

-- 2. Keymaps (Normal and Visual modes)
local default_prefills = function()
  return { paths = project_root() }
end

-- Placeholder for the leader prefix
vim.keymap.set('n', '<leader>.', function() end, { desc = 'GrugFar Search Group' })

-- Normal mode: Regular search and replace using ripgrep
vim.keymap.set('n', '<leader>.r', function()
  require('grug-far').open { prefills = default_prefills() }
end, { desc = 'GrugFar Replace (rg)' })

-- Normal mode: Structural search and replace using ast-grep
vim.keymap.set('n', '<leader>.a', function()
  require('grug-far').open {
    engine = 'astgrep',
    prefills = vim.tbl_extend('force', default_prefills(), { search = '$VAR' }),
  }
end, { desc = 'GrugFar Structural Search (ast-grep)' })

-- Visual mode: Search and replace selected text (ripgrep)
vim.keymap.set('v', '<leader>.v', function()
  require('grug-far').with_visual_selection { prefills = default_prefills() }
end, { desc = 'GrugFar Search (selection)' })

-- Visual mode: Structural search and replace selected text (ast-grep)
vim.keymap.set('v', '<leader>.av', function()
  require('grug-far').with_visual_selection {
    engine = 'astgrep',
    prefills = default_prefills(),
  }
end, { desc = 'GrugFar Structural Search (selection)' })

-- Normal mode: Search and replace the word currently under the cursor
vim.keymap.set('n', '<leader>.w', function()
  require('grug-far').open {
    prefills = vim.tbl_extend('force', default_prefills(), { search = vim.fn.expand '<cword>' }),
  }
end, { desc = 'GrugFar Search (word under cursor)' })
