FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
# Install packages
RUN apt update && apt install -y \
    software-properties-common \
    git curl wget unzip \
    ripgrep fd-find && \
    add-apt-repository ppa:neovim-ppa/unstable -y && \
    apt update && apt install -y neovim && \
    rm -rf /var/lib/apt/lists/*
# Create win32yank wrapper for WSL clipboard
RUN echo '#!/bin/sh' > /usr/local/bin/win32yank && \
    echo 'case "$1" in' >> /usr/local/bin/win32yank && \
    echo '  -o) /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command Get-Clipboard ;;' >> /usr/local/bin/win32yank && \
    echo '  -i) /mnt/c/Windows/System32/clip.exe ;;' >> /usr/local/bin/win32yank && \
    echo 'esac' >> /usr/local/bin/win32yank && \
    chmod +x /usr/local/bin/win32yank
# Clone dotfiles and setup nvim
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git /root/dotfiles && \
    mkdir -p /root/.config && \
    ln -s /root/dotfiles/nvim /root/.config/nvim
WORKDIR /workspace
CMD ["/bin/bash"]