FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
# Install all required packages in one layer
RUN apt update && \
    apt install -y \
    software-properties-common \
    git \
    curl \
    wget \
    unzip \
    ripgrep \
    fd-find \
    && rm -rf /var/lib/apt/lists/*
# Install Neovim
RUN add-apt-repository ppa:neovim-ppa/unstable -y && \
    apt update && \
    apt install -y neovim && \
    rm -rf /var/lib/apt/lists/*
# Install win32yank for clipboard
RUN curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip && \
    unzip -p /tmp/win32yank.zip win32yank.exe > /usr/local/bin/win32yank.exe && \
    chmod +x /usr/local/bin/win32yank.exe && \
    rm /tmp/win32yank.zip
# Clone dotfiles
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git /root/dotfiles
# Setup Neovim config
RUN mkdir -p /root/.config && \
    ln -s /root/dotfiles/nvim /root/.config/nvim
# Pre-install Neovim plugins (lazy.nvim will auto-install on first run)
RUN nvim --headless "+Lazy! sync" +qa || true
WORKDIR /workspace
CMD ["/bin/bash"]