FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
RUN apt update && \
apt-get update && \
apt install -y curl git jq git ripgrep tar unzip wget ca-certificates python3 python3-pip python3-venv tmux man gdb openssh-client nodejs zsh xsel
# Install Neovim v0.12.2
RUN wget https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-x86_64.tar.gz && \
    tar -zxvf nvim-linux-x86_64.tar.gz && \
    mv nvim-linux-x86_64/bin/nvim usr/bin/nvim && \
    mv nvim-linux-x86_64/lib/nvim usr/lib/nvim && \
    mv nvim-linux-x86_64/share/nvim/ usr/share/nvim && \
    rm -rf nvim-linux-x86_64 && \
    rm nvim-linux-x86_64.tar.gz
# Clone dotfiles repository
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git ~/dotfiles
# Install powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 
# Delete default .bashrc
RUN rm ~/.bashrc