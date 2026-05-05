# ============================================================================
# Neovim Development Environment - Complete Docker Image
# ============================================================================
# This Dockerfile creates a complete, self-contained Neovim development 
# environment with all tools pre-installed. No network required after build.
# ============================================================================

FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ============================================================================
# System packages and basic tools
# ============================================================================
RUN apt-get update && apt-get install -y \
    # Core utilities
    curl \
    wget \
    git \
    build-essential \
    unzip \
    tar \
    gzip \
    locales \
    software-properties-common \
    # Search and file tools (used by Telescope and plugins)
    ripgrep \
    fd-find \
    fzf \
    # Clipboard tools
    xclip \
    xsel \
    # Python development
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    # Additional development tools
    make \
    cmake \
    ninja-build \
    gettext \
    # C/C++ development
    gcc \
    g++ \
    clang \
    clang-format \
    # Language specific tools
    lua5.4 \
    luarocks \
    # Database clients
    postgresql-client \
    sqlite3 \
    # Version control
    git-lfs \
    # Utilities for LSP and plugins
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8

# Create symbolic links for fd-find
RUN ln -s $(which fdfind) /usr/local/bin/fd

# ============================================================================
# Configure Git for better network handling
# ============================================================================
RUN git config --global http.postBuffer 524288000 && \
    git config --global http.lowSpeedLimit 1000 && \
    git config --global http.lowSpeedTime 600 && \
    git config --global http.version HTTP/1.1 && \
    git config --global core.compression 0 && \
    git config --global http.sslVerify true

# ============================================================================
# Install Node.js 20.x (LTS)
# ============================================================================
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js version
RUN node --version && npm --version
RUN npm install -g mcp-hub@latest
# ============================================================================
# Install Neovim (from host system)
# ============================================================================
# Copy entire Neovim installation from host
COPY cache/nvim-linux64/ /opt/nvim-linux64/
RUN ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

# Verify Neovim version
RUN nvim --version

# ============================================================================
# Install Python packages
# ============================================================================
RUN pip3 install --no-cache-dir --break-system-packages pynvim

# ============================================================================
# Install Node.js packages globally (none - Mason will handle LSP/formatters)
# ============================================================================
# All LSP servers and formatters will be installed via Mason in Neovim

# ============================================================================
# Install Go 1.23.4 (from pre-downloaded file)
# ============================================================================
ENV GO_VERSION=1.23.4
COPY cache/go${GO_VERSION}.linux-amd64.tar.gz /tmp/go.tar.gz
RUN tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"
ENV GOPATH="/root/go"

# Install Go tools - Mason will handle gopls and dlv
# ============================================================================
# Go compiler is installed, but gopls/dlv will be installed via Mason

# ============================================================================
# Install Rust and Rust analyzer
# ============================================================================
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
# rust-analyzer will be installed via Mason

# ============================================================================
# Install LazyGit (from pre-downloaded file)
# ============================================================================
# Note: The exact filename will be determined at download time
# We'll use a wildcard pattern to find the file
COPY cache/lazygit_*_Linux_x86_64.tar.gz /tmp/lazygit.tar.gz
RUN tar xf /tmp/lazygit.tar.gz -C /tmp lazygit && \
    install /tmp/lazygit /usr/local/bin && \
    rm /tmp/lazygit /tmp/lazygit.tar.gz

# ============================================================================
# Setup workspace
# ============================================================================
WORKDIR /workspace

# Create Neovim config and data directories
# Create Neovim config and data directories
# IMPORTANT: Remove any lazy-lock.json directory that might have been created
RUN mkdir -p /root/.config/nvim \
             /root/.local/share/nvim \
             /root/.local/state/nvim \
             /root/.cache/nvim

# ============================================================================
COPY cache/nvim-data/ /root/.local/share/nvim/
RUN rm -rf /root/.config/nvim/lazy-lock.json

# ============================================================================
# Environment setup
# ============================================================================
ENV PYTHONIOENCODING=utf-8
ENV EDITOR=nvim

# Create a startup script
RUN echo '#!/bin/bash\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo "🚀 Neovim Development Environment (Complete)"\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo ""\n\
echo "📂 Workspace:     /workspace"\n\
echo "⚙️  Config:        /root/.config/nvim"\n\
echo "🔌 Plugins:       /root/.local/share/nvim/lazy"\n\
echo ""\n\
echo "📦 Pre-installed:"\n\
echo "   • Neovim:      $(nvim --version | head -n 1 | cut -d'\'' '\'' -f2)"\n\
echo "   • Node.js:     $(node --version)"\n\
echo "   • Python:      $(python3 --version | cut -d'\'' '\'' -f2)"\n\
echo "   • Go:          $(go version | cut -d'\'' '\'' -f3)"\n\
echo "   • Rust:        $(rustc --version | cut -d'\'' '\'' -f2)"\n\
echo ""\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
exec nvim "$@"' > /usr/local/bin/start-nvim && \
    chmod +x /usr/local/bin/start-nvim

# ============================================================================
# Entry point
# ============================================================================
ENTRYPOINT ["/usr/local/bin/start-nvim"]
CMD []

# ============================================================================
# Build information
# ============================================================================
LABEL maintainer="SHINGO"
LABEL description="Complete Neovim development environment with all tools pre-installed"
LABEL version="1.0"
LABEL tools="neovim,nodejs,python,go,rust,lazygit"
