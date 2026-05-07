FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
# Install packages
RUN apt update && apt install -y \
    software-properties-common git curl wget unzip ripgrep fd-find && \
    add-apt-repository ppa:neovim-ppa/unstable -y && \
    apt update && apt install -y neovim && \
    rm -rf /var/lib/apt/lists/*
# Clone dotfiles and setup nvim
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git /root/dotfiles && \
    mkdir -p /root/.config && \
    ln -s /root/dotfiles/nvim /root/.config/nvim
# Add clipboard configuration to init.lua
RUN echo "" >> /root/.config/nvim/init.lua && \
    echo "-- WSL Docker clipboard configuration" >> /root/.config/nvim/init.lua && \
    echo "vim.g.clipboard = {" >> /root/.config/nvim/init.lua && \
    echo "  name = 'wsl-clip'," >> /root/.config/nvim/init.lua && \
    echo "  copy = {" >> /root/.config/nvim/init.lua && \
    echo "    ['+'] = '/mnt/c/Windows/System32/clip.exe'," >> /root/.config/nvim/init.lua && \
    echo "    ['*'] = '/mnt/c/Windows/System32/clip.exe'" >> /root/.config/nvim/init.lua && \
    echo "  }," >> /root/.config/nvim/init.lua && \
    echo "  paste = {" >> /root/.config/nvim/init.lua && \
    echo "    ['+'] = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -Command Get-Clipboard'," >> /root/.config/nvim/init.lua && \
    echo "    ['*'] = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -Command Get-Clipboard'" >> /root/.config/nvim/init.lua && \
    echo "  }," >> /root/.config/nvim/init.lua && \
    echo "  cache_enabled = false" >> /root/.config/nvim/init.lua && \
    echo "}" >> /root/.config/nvim/init.lua
WORKDIR /workspace
CMD ["/bin/bash"]