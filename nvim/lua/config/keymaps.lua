local fn = require 'config.functions'
local operate_s = fn.functions.utils.detect_os()

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
-- Disable Ctrl+Shift+H/J/K/L for window movement
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`

-- Save :messages to current folder (Windows/Linux compatible)
vim.keymap.set('n', '<leader><leader>m', function()
  local msgs = vim.fn.execute 'messages'
  local lines = vim.split(msgs, '\n')

  -- Create file path according to OS
  local sep = package.config:sub(1, 1) -- For Windows "\"、For Linux "/"
  local logfile = vim.fn.getcwd() .. sep .. 'messages.log'

  -- Add date/time as separator
  table.insert(lines, 1, '==== ' .. os.date '%Y-%m-%d %H:%M:%S' .. ' ====')

  -- Append to file (with "a" flag)
  vim.fn.writefile(lines, logfile, 'a')

  print('Saved :messages to ' .. logfile)
end, { desc = 'Save :messages to file' })

-- Window navigation keymaps (with redraw)
vim.keymap.set('n', '<C-h>', '<C-w>h<Cmd>redraw<CR>')
vim.keymap.set('n', '<C-j>', '<C-w>j<Cmd>redraw<CR>')
vim.keymap.set('n', '<C-k>', '<C-w>k<Cmd>redraw<CR>')
vim.keymap.set('n', '<C-l>', '<C-w>l<Cmd>redraw<CR>')

-- [[VSCode Key binding]]
if vim.g.vscode then
  vim.opt.clipboard = 'unnamedplus'
  vim.keymap.set('n', 'd', '"_d')
  vim.keymap.set('n', 'dd', '"_dd')
  vim.keymap.set('n', '<C-z>', '^')
  vim.keymap.set('n', '<C-e>', '$h')
  vim.keymap.set('v', 'd', '"_d')
  vim.keymap.set('v', '<C-z>', '^')
  vim.keymap.set('v', '<C-e>', '$h')
  -- Removed y and p mappings (handled in keybindings.json)
  -- Leave to VSCode keybindings
else
  vim.opt.clipboard = 'unnamedplus'
end

local wk = require 'which-key'
wk.add {
  {
    mode = { 'n' },
    -- normal mode
    { 'd', '"_d' },
    --  clear highlight
    --  see `:help hlsearch`
    { '<esc>', '<cmd>nohlsearch<cr>', desc = 'clear highlight' },
    { '<leader><leader>x', '<cmd>source %<cr>', desc = 'Source Current File' },
    -- Move to Blank Line
    { ']w', '/^$/<cr>', desc = 'Next Blank Line' },
    { '[w', '?^$<cr>', desc = 'Previous Blank Line' },
    -- <leader> Menu
    { '<leader>f', '', desc = 'File' },
    { '<leader>w', '', desc = 'Vimwiki' },
    -- Quit
    { '<leader>q', '<cmd>confirm qall<cr>', desc = 'Quit Window' },
    { '<leader>Q', '<cmd>confirm qall<cr>', desc = 'Exit Neovim' },
    { ':Q', '<cmd>confirm qall<cr>', desc = 'Exit Neovim' },
    { '<C-S>', '<cmd>silent! update! | redraw<cr>', desc = 'Force write' },
    { 'q', '<cmd>bd!<cr>', { buffer = true } },
    {
      {
        '<leader>fp',
        function()
          local path = vim.fn.expand '%:p'
          print(path)
          vim.fn.setreg('+', path)
        end,
        desc = 'Copy File Path to Clipboard',
      },
    },
    -- { '<leader>g', '', desc = 'Diagnostics' },
    -- { '<leader>gf', '<cmd>lua vim.diagnostic.open_float()<cr>', desc = 'Show Diagnostics Float' },
    -- { '<leader>gl', '<cmd>lua vim.diagnostic.setloclist()<cr>', desc = 'Diagnostics List' },
    -- Pane
    { '<A-.>', ':vertical resize 150<cr>', desc = 'resize pane' },
    { "<A-'>", ':vertical resize +2<cr>', desc = 'resize pane to left' },
    { '<A-;>', ':vertical resize -2<cr>', desc = 'resize pane to right' },
    { '<A-[>', ':resize -2<cr>gc', desc = 'resize pane to up' },
    { '<A-/>', ':resize +2<cr>gc', desc = 'resize pane to down' },
    { '<A-=>', ':sv<cr>', desc = 'Sprit Virtical Pane' },
    { '<A-->', ':vsplit<cr>', desc = 'Sprit Virtical Pane' },
    -- Copilot
    -- { '<leader>k', '', desc = 'Copilot' },
    -- { '<C-[>', ':Copilot suggestion<cr>gc', desc = 'Copilot suggestion' },
    -- { '<leader>kc', '<cmd>CopilotChat<cr>', desc = 'CopilotChat Open' },
    -- { '<leader>kx', '<cmd>CopilotChatClose<cr>', desc = 'CopilotChat Close' },
    -- { '<leader>kf', '<cmd>CopilotChatFix<cr>', desc = 'CopilotChatFix Open' },
    -- { '<leader>ke', '<cmd>Copilot enable<cr>', desc = 'Copilot Enable' },
    -- { '<leader>kd', '<cmd>Copilot disable<cr>', desc = 'Copilot Disable' },
    -- { '<leader>ks', '<cmd>Copilot suggestion<cr>', desc = 'Copilot Suggestion' },
    --Move Line
    { '<C-a>', 'ggVG' },
    { '<A-j>', '<cmd>m .+1<cr>==', desc = 'Move line down' },
    { '<A-k>', '<cmd>m .-2<cr>==', desc = 'Move line up' },
    { '<C-z>', '^', desc = 'Move to head' },
    { '<C-e>', '$', desc = 'Move to end' },
    { '<leader>fc', '<cmd>BufferClose<cr>', desc = 'Buffer Close' },
    -- Open current location for neo-tree
    {
      '<leader>fo',
      function()
        local current_path = vim.fn.expand '%:p:h'

        -- Force load neo-tree
        local ok, neotree_command = pcall(require, 'neo-tree.command')
        if not ok then
          -- Try with vim command if load fails
          vim.cmd 'Neotree show'
          vim.schedule(function()
            vim.cmd('Neotree dir=' .. vim.fn.fnameescape(current_path))
          end)
          return
        end

        -- Open Neotree/modify path
        neotree_command.execute {
          action = 'show',
          dir = current_path,
        }
      end,
      desc = 'Open Current File Location(Neotree)',
    },
    { '<leader>fv', '<cmd>e ' .. vim.fn.fnamemodify(vim.env.MYVIMRC, ':p:h') .. '<cr>', desc = 'Open Nvim Conf Location' },
    { '<leader>fw', '<cmd>e ' .. vim.fn.fnamemodify(vim.env.PROFILE, ':p:h') .. '<cr>', desc = 'Open Windows Profile Location' },
    {
      '<leader>fd',
      function()
        if operate_s == 'windows' then
          vim.cmd 'e F:\\Downloads'
        elseif operate_s == 'wsl' then
          vim.cmd 'e /mnt/f/Downloads'
        elseif operate_s == 'linux' then
          vim.cmd 'e ~/Downloads'
        else
          print 'Unsupported operate_s for this command'
        end
      end,
      desc = 'Open Windows Download Location',
    },
    -- Move focus window
    { '<leader>trp', '<cmd>Pantran<cr>', desc = 'Launch Pantran for translation' },
  },
  {
    mode = { 'i' },
    { 'jk', '<esc>', desc = 'Normal Mode' },
    { '<C-o>', '<esc>o', desc = 'Go to normal mode, create new line' },
    { '<C-z>', '<esc>^i', desc = 'Move to head' },
    { '<C-e>', '<esc>$i<Right>', desc = 'Move to end' },
    { '<C-h>', '<Left>', desc = 'Move to left' },
    { '<C-j>', '<Down>', desc = 'Move to down' },
    { '<C-k>', '<Up>', desc = 'Move to up' },
    { '<C-l>', '<Right>', desc = 'Move to right' },
  },
  {
    mode = { 'v' },
    { 'd', '"_d' },
    { ']w', '/^$/<CR>', desc = 'Next Blank Line' },
    { '[w', '?^$<CR>', desc = 'Previous Blank Line' },
    { '<C-z>', '^', desc = 'Move to head' },
    { '<C-e>', '$', desc = 'Move to end' },
    { '<A-j>', ":m '>+1<cr>gv=gv", mode = 'v', desc = 'Move selection down' },
    { '<A-k>', ":m '<-2<cr>gv=gv", mode = 'v', desc = 'Move selection up' },
    {
      'gs',
      function()
        --Get the selected text
        vim.cmd 'normal! "vy'
        local selected = vim.fn.getreg 'v'

        -- Escape special characters in regular expressions
        selected = selected:gsub('([/\\^$.*+?()[%]{}|])', '\\%1')
        -- Escape newline
        selected = selected:gsub('\n', '\\n')

        -- Start the replace command with the selected text entered
        local cmd = "'<,'>s/" .. selected .. '/'
        vim.api.nvim_feedkeys(':' .. cmd, 'n', false)
      end,
      { noremap = true, desc = 'Replace selected text' },
    },
  },
  {
    mode = { 'x' },
  },
}
