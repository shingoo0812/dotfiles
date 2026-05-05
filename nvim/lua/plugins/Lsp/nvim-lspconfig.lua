local func = require 'config.functions'
local find_venv_root = func.functions.utils.find_venv_root

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local filetype = vim.bo[event.buf].filetype
    if filetype == 'cs' then
      return
    end

    local map = function(keys, fn, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    vim.keymap.set('n', 'gd', function()
      require('telescope.builtin').lsp_definitions {
        show_line = false,
        trim_text = true,
        include_declaration = false,
      }
    end, { buffer = event.buf, desc = 'LSP: [G]oto [D]efinition' })

    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    map('<leader>l', '', 'LSP & terminal & Translate')
    map('<leader>lr', vim.lsp.buf.clear_references, 'Lsp Clear References')
    map('<leader>ld', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>lc', '<cmd>LspStop<cr>', 'Lsp Stop')
    map('<leader>l1', '<cmd>LspStart<cr>', 'Lsp Start')
    map('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client.server_capabilities.inlayHintProvider then
      map('<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
capabilities.textDocument.semanticTokens = nil
capabilities.textDocument.codeLens = nil

local servers = {
  clangd = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = {
          globals = { 'vim' },
          disable = { 'missing-fields', 'inject-field' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },

  csharp_ls = {
    cmd = function()
      local csharp_ls_path = vim.fn.exepath 'csharp-ls'
      if csharp_ls_path == '' then
        csharp_ls_path = vim.fn.stdpath 'data' .. '/mason/bin/csharp-ls'
        if vim.fn.has 'win32' == 1 then
          csharp_ls_path = csharp_ls_path .. '.cmd'
        end
      end
      return { 'cmd', '/C', 'set', 'DOTNET_ROOT=C:\\Program Files\\dotnet', '&&',
        'set', 'PATH=C:\\Program Files\\dotnet;%PATH%', '&&', csharp_ls_path }
    end,
    handlers = {
      ['textDocument/definition'] = require('csharpls_extended').handler,
      ['textDocument/typeDefinition'] = require('csharpls_extended').handler,
    },
    init_options = { AutomaticWorkspaceInit = true },
    settings = {
      csharp = {
        inlayHints = {
          enableInlayHintsForParameters = false,
          enableInlayHintsForLiteralParameters = false,
          enableInlayHintsForIndexerParameters = false,
        },
      },
    },
  },
}

-- QML LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qml', 'qmltypes' },
  callback = function(ev)
    vim.lsp.start {
      name = 'qmlls',
      cmd = { 'qmlls' },
      root_dir = vim.fs.root(ev.buf, { '.qmlls.ini', 'qmlproject', '.git' }),
    }
  end,
})

require('mason').setup()

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, { 'clangd', 'clang-format', 'codelldb', 'pyright', 'csharp_ls', 'ts_ls' })
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

require('mason-lspconfig').setup {
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config[server_name] = server
    end,
  },
}

-- TypeScript
vim.lsp.config.ts_ls = {
  capabilities = capabilities,
  settings = {
    javascript = {
      implicitProjectConfig = {
        checkJs = true,
        jsx = 'react-jsx',
        noImplicitAny = false,
      },
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
vim.lsp.enable 'ts_ls'

-- ESLint
vim.lsp.config.eslint = {
  capabilities = capabilities,
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { 'eslint.config.js', 'eslint.config.mjs', '.eslintrc.js', '.eslintrc.json', '.git' })
    if root then on_dir(root) end
  end,
  settings = {
    validate = 'on',
    useESLintClass = false,
    experimental = { useFlatConfig = true },
    rulesCustomizations = {},
    run = 'onType',
    problems = { shortenToSingleLine = false },
    nodePath = '',
    workingDirectory = { mode = 'location' },
  },
}
vim.lsp.enable 'eslint'

-- Clangd
vim.lsp.config.clangd = {
  cmd = { 'C:\\Program Files\\LLVM\\bin\\clangd.exe' },
  on_attach = function(client, _)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  capabilities = capabilities,
}

-- GLSL
vim.lsp.config.glsl_analyzer = {
  cmd = { 'glsl_analyzer' },
  filetypes = { 'glsl', 'vert', 'frag', 'comp' },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { '.git' })
    on_dir(root or vim.fn.getcwd())
  end,
  capabilities = capabilities,
  settings = { glsl_analyzer = { target = 'opengl' } },
}
vim.lsp.enable 'glsl_analyzer'

-- GDScript
local gdscript_timers = {}

local function start_gdscript_client(bufnr, root_dir, caps)
  local clients = vim.lsp.get_clients { name = 'gdscript' }
  for _, client in ipairs(clients) do
    if client.config.root_dir == root_dir then
      vim.lsp.buf_attach_client(bufnr, client.id)
      return
    end
  end

  local port = tonumber(os.getenv 'GDScript_Port') or 6005
  local client_id = vim.lsp.start {
    name = 'gdscript',
    cmd = vim.lsp.rpc.connect('127.0.0.1', port),
    root_dir = root_dir,
    capabilities = caps,
  }

  if not client_id then return end

  local timer = vim.loop.new_timer()
  gdscript_timers[client_id] = timer
  timer:start(120000, 120000, vim.schedule_wrap(function()
    local c = vim.lsp.get_client_by_id(client_id)
    if c and not c.is_stopped() then
      pcall(vim.lsp.buf_attach_client, bufnr, client_id)
    else
      timer:stop()
      timer:close()
      gdscript_timers[client_id] = nil
    end
  end))

  vim.api.nvim_create_autocmd('BufDelete', {
    buffer = bufnr,
    once = true,
    callback = function()
      if timer then
        timer:stop()
        timer:close()
        gdscript_timers[client_id] = nil
      end
    end,
  })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gd', 'gdscript', 'gdscript3' },
  callback = function(ev)
    local root_dir = vim.fs.root(ev.buf, { 'project.godot', '.git' })
    start_gdscript_client(ev.buf, root_dir, capabilities)
  end,
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})

-- Python (pyright with venv detection)
local pyright_venv_cache = {}
vim.lsp.config.pyright = {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'basic',
      },
    },
  },
  flags = {
    debounce_text_changes = 100,
    allow_incremental_sync = true,
    exit_timeout = 1000,
  },
  before_init = function(params, config)
    local root_path = params.rootPath or vim.fn.getcwd()
    if pyright_venv_cache[root_path] then
      config.settings.python.pythonPath = pyright_venv_cache[root_path]
      return
    end
    local venv_root = find_venv_root(root_path)
    if not venv_root then return end
    local python_path
    if func.functions.utils.detect_os() == 'windows' then
      python_path = venv_root .. '/Scripts/python.exe'
    else
      python_path = venv_root .. '/bin/python'
    end
    if vim.fn.filereadable(python_path) == 0 then
      print('pythonExecuteFile not found:', python_path)
      return
    end
    pyright_venv_cache[root_path] = python_path
    config.settings.python.pythonPath = python_path
  end,
}
