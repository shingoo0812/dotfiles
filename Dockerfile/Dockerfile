FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]

RUN apt update && \
apt-get update && \
apt install -y curl git jq git ripgrep tar unzip wget python3 python3-pip python3-venv tmux man gdb openssh-client


# nvim install
RUN wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz && \
    tar -zxvf nvim-linux64.tar.gz && \
    mv nvim-linux64/bin/nvim usr/bin/nvim && \
    mv nvim-linux64/lib/nvim usr/lib/nvim && \
    mv nvim-linux64/share/nvim/ usr/share/nvim && \
    rm -rf nvim-linux64 && \
    rm nvim-linux64.tar.gz


#add my dotfiles
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git

RUN rm ~/.bashrc

