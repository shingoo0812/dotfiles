local actions = require 'telescope.actions'

local function open_selected(prompt_bufnr)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local selected = picker:get_multi_selection()
  if vim.tbl_isempty(selected) then
    actions.select_default(prompt_bufnr)
  else
    actions.close(prompt_bufnr)
    for _, file in pairs(selected) do
      if file.path then
        vim.cmd('edit' .. (file.lnum and ' +' .. file.lnum or '') .. ' ' .. file.path)
      end
    end
  end
end

local function open_all(prompt_bufnr)
  actions.select_all(prompt_bufnr)
  open_selected(prompt_bufnr)
end

require('telescope').load_extension 'notify'

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-J>'] = actions.move_selection_next,
        ['<C-K>'] = actions.move_selection_previous,
        ['<CR>'] = open_selected,
        ['<M-CR>'] = open_all,
      },
      n = {
        q = actions.close,
        ['<CR>'] = open_selected,
        ['<M-CR>'] = open_all,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'

vim.keymap.set('n', '<leader>s', '', { desc = 'Telescope' })
vim.keymap.set('n', '<leader>s?', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })

vim.keymap.set('n', '<leader>sf', function()
  local root = vim.fs.root(0, { '.git', '.hg', '.svn' }) or vim.fn.expand '%:p:h'
  builtin.find_files { cwd = root, hidden = true, no_ignore = true, no_ignore_parent = true }
end, { desc = '[S]earch [F]iles from project root' })

vim.keymap.set('n', '<leader>s,', function()
  local root = vim.fs.root(0, { '.git', '.hg', '.svn' }) or vim.fn.expand '%:p:h'
  builtin.live_grep { cwd = root, additional_args = { '--hidden', '--no-ignore' } }
end, { desc = '[S]earch by [G]rep from project root' })

vim.keymap.set('n', '<leader>sw', function()
  local root = vim.fs.root(0, { '.git', '.hg', '.svn' }) or vim.fn.expand '%:p:h'
  builtin.grep_string { cwd = root, additional_args = { '--hidden', '--no-ignore' } }
end, { desc = '[S]earch current [W]ord from project root' })

vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })

vim.keymap.set('n', '<leader>sg', '', { desc = '[S]earch [G]it' })
vim.keymap.set('n', '<leader>sgc', '<cmd>Telescope git_commits<cr>', { desc = '[S]earch [G]it [C]ommits' })
vim.keymap.set('n', '<leader>sgb', '<cmd>Telescope git_bcommits<cr>', { desc = '[S]earch [G]it [B]Commits' })
vim.keymap.set('n', '<leader>sgs', '<cmd>Telescope git_status<cr>', { desc = '[S]earch [G]it [S]tatus' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('v', '<leader>/', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)
  vim.schedule(function()
    local start_pos = vim.fn.getpos "'<"
    local end_pos = vim.fn.getpos "'>"
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
    local selected_text = #lines == 1
      and string.sub(lines[1], start_pos[3], end_pos[3])
      or string.sub(lines[1], start_pos[3])
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
      default_text = selected_text,
    })
  end)
end, { desc = '[/] Fuzzily search selection in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

vim.keymap.set('n', '<leader>sP', function() builtin.find_files() end, { desc = '[S]earch [P]roject files' })
vim.keymap.set('n', '<leader>sG', function() builtin.live_grep() end, { desc = '[S]earch by [G]rep in project' })
