FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
RUN apt update && \
apt-get update && \
apt install -y curl git jq git ripgrep tar unzip wget ca-certificates python3 python3-pip python3-venv tmux man gdb openssh-client nodejs zsh xsel software-properties-common
# Install Neovim v0.12.x from official PPA (more reliable than downloading)
RUN add-apt-repository ppa:neovim-ppa/unstable -y && \
    apt update && \
    apt install -y neovim
# Clone dotfiles repository
RUN git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git ~/dotfiles
# Install powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 
# Delete default .bashrc
RUN rm ~/.bashrc