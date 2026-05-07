FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
RUN apt update && \
apt-get update && \
apt install -y curl git jq git ripgrep tar unzip wget ca-certificates python3 python3-pip python3-venv tmux man gdb openssh-client nodejs zsh xsel software-properties-common
# Install Neovim v0.12.x from official PPA
RUN add-apt-repository ppa:neovim-ppa/unstable -y && \
    apt update && \
    apt install -y neovim
# Configure git for better network stability
RUN git config --global http.postBuffer 524288000 && \
    git config --global http.lowSpeedLimit 0 && \
    git config --global http.lowSpeedTime 999999
# Clone dotfiles repository with retry logic
RUN for i in 1 2 3 4 5; do \
        git clone --depth=1 --recursive https://github.com/shingoo0812/dotfiles.git ~/dotfiles && break || \
        echo "Retry $i failed, waiting..." && sleep 5; \
    done
# Setup dotfiles using bootstrap script (creates symlinks automatically)
RUN cd ~/dotfiles && \
    chmod +x install/bootstrap.sh && \
    export DOTFILES=~/dotfiles && \
    yes "S" | bash install/bootstrap.sh || true
# Create symlink for nvim config (not included in bootstrap)
RUN ln -sf ~/dotfiles/nvim ~/.config/nvim
# Install powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 