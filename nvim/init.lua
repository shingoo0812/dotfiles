--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
--]]

require 'config.init'
require 'config.functions'

-- [[ GLSL Filetype Configuration ]]
vim.filetype.add {
  extension = {
    vert = 'glsl',
    frag = 'glsl',
    comp = 'glsl',
  },
}

-- [[ Install plugins via vim.pack (Neovim 0.12 built-in) ]]
vim.pack.add {
  -- Core dependencies (loaded first)
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/nvim-tree/nvim-tree.lua',

  -- Treesitter (note: run :TSUpdate manually after first install)
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',

  -- Theme
  'https://github.com/neanias/everforest-nvim',
  'https://github.com/sainnhe/gruvbox-material',

  -- UI
  'https://github.com/folke/which-key.nvim',
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  { src = 'https://github.com/s1n7ax/nvim-window-picker', version = 'v2.4.0' },
  { src = 'https://github.com/romgrk/barbar.nvim', version = 'v1.9.1' },
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/Bekaboo/dropbar.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/shellRaining/hlchunk.nvim',
  'https://github.com/rcarriga/nvim-notify',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/HiPhish/rainbow-delimiters.nvim',
  'https://github.com/bassamsdata/namu.nvim',
  'https://github.com/eero-lehtinen/oklch-color-picker.nvim',
  'https://github.com/nosduco/remote-sshfs.nvim',
  'https://github.com/folke/zen-mode.nvim',

  -- Completion
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/saadparwaiz1/cmp_luasnip',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-path',

  -- Editing
  'https://github.com/kevinhwang91/nvim-ufo',
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/rmagatti/auto-session',
  'https://github.com/chentoast/marks.nvim',
  'https://github.com/rainbowhxch/accelerated-jk.nvim',
  'https://github.com/sphamba/smear-cursor.nvim',
  'https://github.com/mg979/vim-visual-multi',
  'https://github.com/junegunn/vim-easy-align',
  { src = 'https://github.com/benlubas/molten-nvim', version = 'v1.9.2' },
  'https://github.com/jbyuki/venn.nvim',
  'https://github.com/GCBallesteros/jupytext.nvim',
  'https://github.com/folke/noice.nvim',

  -- LSP & Tools
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/rhysd/vim-clang-format',
  'https://github.com/Decodetalkers/csharpls-extended-lsp.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/dnlhc/glance.nvim',
  'https://github.com/danymat/neogen',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/antosha417/nvim-lsp-file-operations',
  'https://github.com/rachartier/tiny-inline-diagnostic.nvim',

  -- Git
  'https://github.com/kdheepak/lazygit.nvim',

  -- Search
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = 'master' },
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/MagicDuck/grug-far.nvim',

  -- Testing
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/haydenmeade/neotest-jest',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/leoluz/nvim-dap-go',
  'https://github.com/mfussenegger/nvim-dap-python',

  -- AI
  'https://github.com/coder/claudecode.nvim',
  { src = 'https://github.com/olimorris/codecompanion.nvim', version = 'v17.33.0' },
  'https://github.com/David-Kunz/gen.nvim',
  'https://github.com/ravitemer/mcphub.nvim',

  -- Wiki
  'https://github.com/OXY2DEV/markview.nvim',
  'https://github.com/epwalsh/obsidian.nvim',
  'https://github.com/vimwiki/vimwiki',

  -- Misc
  'https://github.com/kalvinpearce/ShaderHighlight',
  'https://github.com/lambdalisue/vim-suda',
  'https://github.com/tpope/vim-unimpaired',
  'https://github.com/folke/persistence.nvim',
  'https://github.com/mistweaverco/kulala.nvim',
  'https://github.com/potamides/pantran.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/EvWilson/spelunk.nvim',
  'https://github.com/akinsho/toggleterm.nvim',
  'https://github.com/uga-rosa/translate.nvim',
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
  'https://github.com/gruvw/strudel.nvim',
  'https://github.com/andweeb/presence.nvim',
  'https://github.com/ray-x/lsp_signature.nvim',
  'https://github.com/goolord/alpha-nvim',
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
}

-- Run build steps after plugin install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function()
    pcall(vim.cmd, 'TSUpdate')
    pcall(vim.cmd, 'UpdateRemotePlugins')
  end,
})

-- [[ Load plugin configurations ]]
local function load_plugin_configs(base_path, prefix)
  local items = vim.fn.readdir(base_path)
  table.sort(items)
  for _, item in ipairs(items) do
    local full_path = base_path .. '/' .. item
    if vim.fn.isdirectory(full_path) == 1 then
      load_plugin_configs(full_path, prefix .. item .. '.')
    elseif item:match '%.lua$' then
      local module = prefix .. item:gsub('%.lua$', '')
      local ok, err = pcall(require, module)
      if not ok then
        vim.notify('Error loading plugin config ' .. module .. ': ' .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end
end

load_plugin_configs(vim.fn.stdpath 'config' .. '/lua/plugins', 'plugins.')

-- [[Read Configuration folders(./lua/config/*.lua)]]
local config_path = vim.fn.stdpath 'config' .. '/lua/config'
local skip_files = {
  ['init.lua'] = true,
  ['functions.lua'] = true,
}

local function load_config_recursive(base_path, module_prefix)
  local files = vim.fn.readdir(base_path)

  for _, file in ipairs(files) do
    local full_path = base_path .. '/' .. file

    if vim.fn.isdirectory(full_path) == 1 then
      local new_prefix = module_prefix .. file .. '.'
      load_config_recursive(full_path, new_prefix)
    else
      if file:match '%.lua$' and not skip_files[file] then
        local module_name = module_prefix .. file:gsub('%.lua$', '')
        local ok, result = pcall(require, module_name)
        if not ok then
          vim.notify('Error loading ' .. module_name .. ': ' .. tostring(result), vim.log.levels.ERROR)
        elseif type(result) == 'table' and result.setup then
          local setup_ok, setup_err = pcall(result.setup)
          if not setup_ok then
            vim.notify('Error in ' .. module_name .. '.setup(): ' .. tostring(setup_err), vim.log.levels.ERROR)
          end
        end
      end
    end
  end
end

load_config_recursive(config_path, 'config.')

-- vim: ts=2 sts=2 sw=2 et
