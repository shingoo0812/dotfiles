FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]

# Install base packages and build tools
RUN apt-get update && apt-get install -y \
    software-properties-common \
    git curl wget unzip \
    ripgrep fd-find \
    gcc g++ make cmake \
    python3 python3-pip python3-venv \
    nodejs npm \
    luarocks \
    tar gzip xz-utils \
    ca-certificates locales \
    imagemagick \
    && add-apt-repository ppa:neovim-ppa/unstable -y \
    && apt-get update && apt-get install -y neovim \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK 10.0 and csharp-ls in a single RUN to avoid PATH issues
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 10.0 \
    && ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet \
    && /root/.dotnet/dotnet tool install -g csharp-ls --version 0.23.0

# Set dotnet environment variables
ENV DOTNET_ROOT=/root/.dotnet
ENV PATH=$PATH:/root/.dotnet:/root/.dotnet/tools

# Install global npm packages
RUN npm install -g tree-sitter-cli mcp-hub@latest

# Install luarocks magick for image display
RUN luarocks --local install magick

# Clone dotfiles with retry logic and increased buffer to handle unstable network
RUN git config --global http.postBuffer 524288000 \
    && for i in 1 2 3 4 5; do \
      git clone --depth=1 https://github.com/shingoo0812/dotfiles.git /root/dotfiles && break; \
      echo "Retry $i failed, retrying..."; sleep 5; \
    done \
    && mkdir -p /root/.config \
    && ln -s /root/dotfiles/nvim /root/.config/nvim

RUN cd /root/dotfiles && git submodule update --init --recursive --depth=1

# Remove csharp_ls from Mason ensure_installed (Mason's NuGet package is broken;
# csharp-ls is already installed via dotnet tool and accessible via PATH)
RUN sed -i "s/'csharp_ls', //g; s/, 'csharp_ls'//g; s/'csharp_ls'//g" \
    /root/dotfiles/nvim/lua/plugins/Lsp/nvim-lspconfig.lua

# Patch Obsidian vault path: replace Windows path with Linux mount path
RUN grep -rl "F:/Documents/ObsidianVault" /root/dotfiles/nvim \
    | xargs sed -i 's|F:/Documents/ObsidianVault|/mnt/f/Documents/ObsidianVault|g'

# Append clipboard: OSC52 copy, register fallback for paste
# Paste from host: use WezTerm Ctrl+Shift+V or right-click
RUN python3 - << 'PYEOF'
cfg = """
-- Clipboard: OSC52 copy, register fallback paste
-- To paste from host clipboard: use WezTerm Ctrl+Shift+V in insert mode
local function paste()
  return { vim.fn.split(vim.fn.getreg(chr(39)chr(34)chr(39)), chr(39)\\nchr(39)), vim.fn.getregtype(chr(39)chr(34)chr(39)) }
end
vim.g.clipboard = {
  name = 'OSC 52',
  copy  = { ['+'] = require('vim.ui.clipboard.osc52').copy('+'), ['*'] = require('vim.ui.clipboard.osc52').copy('*') },
  paste = { ['+'] = paste, ['*'] = paste },
}
"""
with open('/root/.config/nvim/init.lua', 'a') as f:
    f.write(cfg)
PYEOF

# Pre-install Neovim plugins at build time to avoid timeout on first launch
RUN nvim --headless -c 'lua vim.pack.sync()' -c 'qa' 2>&1 | tail -10 || true

WORKDIR /workspace
CMD ["/bin/bash"]
