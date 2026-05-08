FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
# Install base packages, build tools, and .NET SDK dependencies
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
    dotnet-sdk-8.0 \
    && add-apt-repository ppa:neovim-ppa/unstable -y \
    && apt-get update && apt-get install -y neovim \
    && rm -rf /var/lib/apt/lists/*
# Install global npm packages
RUN npm install -g tree-sitter-cli mcp-hub@latest
# Install luarocks magick for image display
RUN luarocks --local install magick
# Clone dotfiles and setup nvim
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git /root/dotfiles \
    && mkdir -p /root/.config \
    && ln -s /root/dotfiles/nvim /root/.config/nvim
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
