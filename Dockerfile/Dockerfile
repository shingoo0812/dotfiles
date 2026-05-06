FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
RUN apt update && \
apt-get update && \
apt install -y curl git jq git ripgrep tar unzip wget ca-certificates python3 python3-pip python3-venv tmux man gdb openssh-client nodejs zsh xsel
# Nvim install (v0.12.2 - ファイル名が変更されています)
RUN wget https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux64.tar.gz && \
    tar -zxvf nvim-linux64.tar.gz && \
    mv nvim-linux64/bin/nvim usr/bin/nvim && \
    mv nvim-linux64/lib/nvim usr/lib/nvim && \
    mv nvim-linux64/share/nvim/ usr/share/nvim && \
    rm -rf nvim-linux64 && \
    rm nvim-linux64.tar.gz
#Add my dotfiles
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git ~/dotfiles
# Install powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 
# Delete .bashrc
RUN rm ~/.bashrc