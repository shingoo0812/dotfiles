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
    openssh-server \
    python-is-python3 \
    && add-apt-repository ppa:neovim-ppa/unstable -y \
    && apt-get update && apt-get install -y neovim \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for all sessions including SSH
RUN echo 'export DOTNET_ROOT=/root/.dotnet' >> /root/.profile \
    && echo 'export PATH=$PATH:/root/.dotnet:/root/.dotnet/tools' >> /root/.profile \
    && echo 'export JUPYTER_RUNTIME_DIR=/root/.local/share/jupyter/runtime' >> /root/.profile \
    && echo 'export TERM=wezterm' >> /root/.profile

# Configure SSH server
RUN mkdir -p /var/run/sshd /root/.ssh \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config \
    && chmod 700 /root/.ssh

# Install .NET SDK 10.0 and csharp-ls in a single RUN to avoid PATH issues
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 10.0 \
    && ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet \
    && /root/.dotnet/dotnet tool install -g csharp-ls --version 0.23.0

# Set dotnet environment variables
ENV DOTNET_ROOT=/root/.dotnet
ENV PATH=$PATH:/root/.dotnet:/root/.dotnet/tools

# Install lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit \
    && rm /tmp/lazygit.tar.gz

# Install Python packages required for Molten
RUN pip install --break-system-packages pynvim jupyter_client ipykernel matplotlib numpy

# Install global npm packages
RUN npm install -g tree-sitter-cli

# Install luarocks magick for image display
RUN luarocks install magick

# Copy nvim config directly from host build context (no network dependency)
COPY nvim /root/dotfiles/nvim
RUN mkdir -p /root/.config \
    && ln -s /root/dotfiles/nvim /root/.config/nvim

# Disable mcphub plugin (mcp-hub not available in Docker)
RUN rm /root/dotfiles/nvim/lua/plugins/AI/mcphub.lua

# Remove csharp_ls from Mason ensure_installed (Mason's NuGet package is broken;
# csharp-ls is already installed via dotnet tool and accessible via PATH)
RUN sed -i "s/'csharp_ls', //g; s/, 'csharp_ls'//g; s/'csharp_ls'//g" \
    /root/dotfiles/nvim/lua/plugins/Lsp/nvim-lspconfig.lua

# Patch Obsidian vault path: replace Windows path with Linux mount path
RUN grep -rl "F:/Documents/ObsidianVault" /root/dotfiles/nvim \
    | xargs sed -i 's|F:/Documents/ObsidianVault|/mnt/f/Documents/ObsidianVault|g'

# Append clipboard configuration from patch file
RUN cat /root/dotfiles/nvim/clipboard_patch.lua >> /root/.config/nvim/init.lua


# Pre-install Neovim plugins at build time to avoid timeout on first launch
# Pre-install plugins with extended timeout (10 minutes)
RUN nvim --headless \
    --cmd 'lua local o=vim.wait; vim.wait=function(_,...)return o(600000,...)end' \
    -c 'lua vim.pack.sync()' \
    -c 'qa' 2>&1 || true
# Register remote plugins and create Jupyter runtime directory
RUN nvim --headless -c 'UpdateRemotePlugins' -c 'qa' 2>&1 || true
RUN mkdir -p /root/.local/share/jupyter/runtime
WORKDIR /workspace
CMD ["bash", "-c", "mkdir -p /root/.ssh /root/.local/share/jupyter/runtime && cp /wsl/home/.ssh/id_ed25519.pub /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && service ssh start && tail -f /dev/null"]
