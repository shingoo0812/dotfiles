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
# Install .NET SDK 8.0 via Microsoft official script
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 8.0 \
    && ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet
# Set dotnet environment variables (tools dir required for Mason's dotnet tool install)
ENV DOTNET_ROOT=/root/.dotnet
ENV PATH=$PATH:/root/.dotnet:/root/.dotnet/tools
# Pre-install csharp-ls with a known working version to bypass Mason's broken package
# Then symlink to Mason's bin dir so Mason treats it as installed
RUN dotnet tool install -g csharp-ls --version 0.17.0 \
    && mkdir -p /root/.local/share/nvim/mason/bin \
    && ln -sf /root/.dotnet/tools/csharp-ls /root/.local/share/nvim/mason/bin/csharp-ls
# Install global npm packages
RUN npm install -g tree-sitter-cli mcp-hub@latest
# Install luarocks magick for image display
RUN luarocks --local install magick
# Clone dotfiles and setup nvim
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git /root/dotfiles \
    && mkdir -p /root/.config \
    && ln -s /root/dotfiles/nvim /root/.config/nvim
# Patch Obsidian vault path: replace Windows path with Linux mount path
RUN grep -rl "F:/Documents/ObsidianVault" /root/dotfiles/nvim \
    | xargs sed -i 's|F:/Documents/ObsidianVault|/mnt/f/Documents/ObsidianVault|g'
# Append clipboard configuration using OSC52 (works inside Docker over terminal)
RUN echo "" >> /root/.config/nvim/init.lua && \
    echo "-- Clipboard configuration using OSC52 (Docker compatible)" >> /root/.config/nvim/init.lua && \
    echo "vim.g.clipboard = {" >> /root/.config/nvim/init.lua && \
    echo "  name = 'OSC 52'," >> /root/.config/nvim/init.lua && \
    echo "  copy = {" >> /root/.config/nvim/init.lua && \
    echo "    ['+'] = require('vim.ui.clipboard.osc52').copy('+')," >> /root/.config/nvim/init.lua && \
    echo "    ['*'] = require('vim.ui.clipboard.osc52').copy('*')," >> /root/.config/nvim/init.lua && \
    echo "  }," >> /root/.config/nvim/init.lua && \
    echo "  paste = {" >> /root/.config/nvim/init.lua && \
    echo "    ['+'] = require('vim.ui.clipboard.osc52').paste('+')," >> /root/.config/nvim/init.lua && \
    echo "    ['*'] = require('vim.ui.clipboard.osc52').paste('*')," >> /root/.config/nvim/init.lua && \
    echo "  }," >> /root/.config/nvim/init.lua && \
    echo "}" >> /root/.config/nvim/init.lua
WORKDIR /workspace
CMD ["/bin/bash"]
