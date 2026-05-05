local M = {}

----------------------------------------------
-- Functions
----------------------------------------------
M.functions = {
  -- General utilities
  utils = {
    -- Save Vim messages to a file
    save_message = function(filename)
      local msgs = vim.fn.execute 'messages'
      local f = io.open(filename, 'w')
      if f then
        f:write(msgs)
        f:close()
        print('Messages saved to ' .. filename)
      else
        print('Failed to open file: ' .. filename)
      end
    end,

    -- Normalize path separators
    normalize_path = function(p)
      return p:gsub('\\', '/')
    end,
    test = function()
      return 'test'
    end,

    -- TODO: Replace with Neovim-native functionality
    -- Get Git root directory or current file's directory
    -- Function to detect project root
    get_project_root = function()
      local root_patterns = { '.git', 'package.json', 'Cargo.toml', 'go.mod', 'pyproject.toml' }
      local current_file = vim.fn.expand '%:p:h'

      for _, pattern in ipairs(root_patterns) do
        local root = vim.fn.finddir(pattern, current_file .. ';')
        if root ~= '' then
          return vim.fn.fnamemodify(root, ':h')
        end

        local file = vim.fn.findfile(pattern, current_file .. ';')
        if file ~= '' then
          return vim.fn.fnamemodify(file, ':h')
        end
      end

      return current_file
    end,
    -- TODO: Replace with Neovim-native functionality
    -- OS detection
    detect_os = function()
      -- Using jit.os is the fastest and most common way in Neovim/LuaJIT
      local os = string.lower(jit.os)

      if os == 'windows' then
        -- Check for WSL if you specifically need to distinguish it from native Linux
        if vim.fn.has 'wsl' == 1 then
          return 'wsl'
        end
        return 'windows'
      elseif os == 'osx' then
        return 'mac'
      elseif os == 'linux' then
        return 'linux'
      else
        return 'unknown'
      end
    end,
    -- Find the root of a Python virtual environment by looking for a `.venv` folder
    find_venv_root = function(path)
      local utils = M.functions.utils

      -- Determine if path is folder or file and process correctly
      local current
      if vim.fn.isdirectory(path) == 1 then
        current = path
      else
        current = vim.fn.fnamemodify(path, ':h')
      end

      for _ = 1, 100 do
        local venv_path = (utils.detect_os() == 'windows') and (current .. '\\.venv') or (current .. '/.venv') or (current .. '/venv') or (current .. '\\venv')

        if vim.fn.isdirectory(venv_path) == 1 then
          return venv_path
        end

        local parent = vim.fn.fnamemodify(current, ':h')

        if parent == current or parent == '' or parent == '.' then
          break
        end

        current = parent
      end

      return nil
    end,
    -- More utility functions can be added here
  },

  -- LSP related
  lsp = {
    check_status = function()
      local clients = vim.lsp.get_clients()
      if #clients > 0 then
        for _, client in ipairs(clients) do
          vim.notify(client.name .. ' is running', vim.log.levels.INFO)
        end
      else
        vim.notify('No LSP clients are running', vim.log.levels.WARN)
      end
    end,

    debug_info = function()
      local filetype = vim.bo.filetype
      local clients = vim.lsp.get_clients { bufnr = 0 }
      vim.notify('Current filetype: ' .. filetype, vim.log.levels.INFO)

      if #clients > 0 then
        for _, client in ipairs(clients) do
          vim.notify('Active LSP: ' .. client.name, vim.log.levels.INFO)
        end
      else
        vim.notify('No LSP attached to current buffer', vim.log.levels.WARN)
        if filetype == 'cs' then
          vim.notify('C# files use OmniSharp-vim instead of LSP', vim.log.levels.INFO)
        end
      end
    end,
    -- More LSP-related functions can be added here
  },

  -- Unity/C# related
  unity = {
    modify_csproj = function()
      if vim.fn.has 'win32' == 1 then
        vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|C:\\|/mnt/c/|g"'
        vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|D:\\|/mnt/d/|g"'
        vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|E:\\|/mnt/e/|g"'
        vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|F:\\|/mnt/f/|g"'
      else
        vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/C:/\\/mnt\\/c/g"'
        vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/D:/\\/mnt\\/d/g"'
        vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/E:/\\/mnt\\/e/g"'
        vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/F:/\\/mnt\\/f/g"'
      end

      if vim.fn.exists ':YcmCompleter' == 1 then
        vim.cmd 'YcmCompleter ReloadSolution'
      end
    end,
  },
}

----------------------------------------------
-- Commands
----------------------------------------------
M.commands = {
  -- Utilities
  {
    name = 'MsgLog',
    func = function(opts)
      M.functions.utils.save_message(opts.args)
    end,
    nargs = 1,
    desc = 'Save Vim messages to a file',
  },
  {
    name = 'normalize_path',
    func = function(opts)
      M.functions.utils.normalize_path(opts.args)
    end,
  },
  {
    name = 'test',
    func = M.functions.utils.test,
  },
  {
    name = 'ProjectRoot',
    func = function()
      local root = M.functions.utils.get_project_root()
      print('Project root: ' .. root)
    end,
    desc = 'Get the project root directory',
  },
  -- LSP related
  {
    name = 'LspStatus',
    func = M.functions.lsp.check_status,
    desc = 'Check LSP status for all languages except C#',
  },
  {
    name = 'LspDebugInfo',
    func = M.functions.lsp.debug_info,
    desc = 'Debug LSP information for current buffer',
  },

  -- Unity/C# related
  {
    name = 'ModifyCSProjFile',
    func = M.functions.unity.modify_csproj,
    desc = 'Fix C# project paths for WSL/Unix',
  },

  -- For testing
  {
    name = 'TestCommand',
    func = function()
      print 'This is a test command.'
    end,
  },
}

----------------------------------------------
-- Setup
----------------------------------------------
function M.setup() end

return M
