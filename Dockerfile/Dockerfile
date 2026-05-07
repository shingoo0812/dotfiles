FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
# Install basic packages
RUN apt update && \
    apt install -y \
    software-properties-common \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*
# Install Neovim from PPA
RUN add-apt-repository ppa:neovim-ppa/unstable -y && \
    apt update && \
    apt install -y neovim && \
    rm -rf /var/lib/apt/lists/*
# Clone dotfiles with submodules
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git /root/dotfiles
# Setup Neovim config
RUN mkdir -p /root/.config && \
    ln -s /root/dotfiles/nvim /root/.config/nvim
WORKDIR /workspace