#!/bin/bash
# ============================================================================
# Prepare cache from host system
# ============================================================================
# This script copies your existing Neovim setup to Docker cache
# ============================================================================

set -e

# ============================================================================
# Configuration - Edit these paths if needed
# ============================================================================

# Neovim binary path (leave empty for auto-detection)
NVIM_BIN_PATH=""  # e.g., "/opt/nvim-linux64/bin/nvim"

# Neovim data directory (leave empty for default: ~/.local/share/nvim)
NVIM_DATA_PATH=""  # e.g., "/custom/path/to/nvim/data"

# Go version to download (if needed)
GO_VERSION="1.23.4"

# ============================================================================
# Script starts here
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="${SCRIPT_DIR}/cache"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Preparing cache from host system"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create cache directory
mkdir -p "${CACHE_DIR}"

# ============================================================================
# Copy Neovim binary
# ============================================================================
echo "Copying Neovim..."

# Use configured path or auto-detect
if [ -n "$NVIM_BIN_PATH" ]; then
    NVIM_BIN="$NVIM_BIN_PATH"
    echo "  Using configured path: $NVIM_BIN"
elif command -v nvim &> /dev/null; then
    NVIM_BIN=$(which nvim)
    echo "  Auto-detected: $NVIM_BIN"
else
    echo "✗ Neovim not found"
    echo "  Please set NVIM_BIN_PATH in this script or install Neovim"
    exit 1
fi

NVIM_DIR=$(dirname $(dirname "$NVIM_BIN"))

if [ -d "$NVIM_DIR" ]; then
    echo "  Neovim directory: $NVIM_DIR"
    rm -rf "${CACHE_DIR}/nvim-linux64"
    cp -r "$NVIM_DIR" "${CACHE_DIR}/nvim-linux64"
    echo "✓ Neovim copied"
else
    echo "✗ Could not determine Neovim directory"
    exit 1
fi

# ============================================================================
# Copy Neovim data directory (plugins, Lazy.nvim, etc.)
# ============================================================================
echo "Copying Neovim data (plugins)..."

# Use configured path or default
if [ -n "$NVIM_DATA_PATH" ]; then
    NVIM_DATA="$NVIM_DATA_PATH"
    echo "  Using configured path: $NVIM_DATA"
else
    NVIM_DATA="$HOME/.local/share/nvim"
    echo "  Using default path: $NVIM_DATA"
fi

if [ -d "$NVIM_DATA" ]; then
    rm -rf "${CACHE_DIR}/nvim-data"
    cp -r "$NVIM_DATA" "${CACHE_DIR}/nvim-data"
    echo "✓ Neovim data copied"
    echo "  Size: $(du -sh ${CACHE_DIR}/nvim-data | cut -f1)"
else
    echo "⚠ Neovim data directory not found at: $NVIM_DATA"
    echo "  Creating empty directory..."
    mkdir -p "${CACHE_DIR}/nvim-data"
    echo "  Plugins will be installed on first run"
fi

# ============================================================================
# Download Go (optional - only if you need Go)
# ============================================================================
GO_VERSION="1.23.4"
GO_FILE="${CACHE_DIR}/go${GO_VERSION}.linux-amd64.tar.gz"

if [ -f "${GO_FILE}" ]; then
    echo "✓ Go already downloaded: ${GO_FILE}"
else
    read -p "Download Go ${GO_VERSION}? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Downloading Go ${GO_VERSION}..."
        wget -O "${GO_FILE}" \
            "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
        echo "✓ Go downloaded"
    else
        echo "⊘ Skipped Go download"
    fi
fi
# ============================================================================
# Copy lazygit
# ============================================================================
echo "📦 Copying lazygit..."
LAZYGIT_PATH=$(which lazygit 2>/dev/null || echo "")
if [ -n "$LAZYGIT_PATH" ]; then
    # lazygitのバージョンを取得
    LAZYGIT_VERSION=$(lazygit --version 2>/dev/null | grep -oP 'version=\K[0-9.]+' || echo "0.44.1")
    
    # tar.gzとして保存（Dockerfileの期待する形式に合わせる）
    LAZYGIT_ARCHIVE="${CACHE_DIR}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    
    # 一時ディレクトリでtar作成
    TEMP_DIR=$(mktemp -d)
    cp "$LAZYGIT_PATH" "$TEMP_DIR/lazygit"
    tar czf "$LAZYGIT_ARCHIVE" -C "$TEMP_DIR" lazygit
    rm -rf "$TEMP_DIR"
    
    echo "✓ Lazygit cached: $(basename $LAZYGIT_ARCHIVE)"
else
    echo "⚠ Lazygit not found on host, skipping..."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Cache prepared successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Cache directory: ${CACHE_DIR}"
echo ""
echo "Contents:"
du -sh "${CACHE_DIR}"/* 2>/dev/null || echo "  (empty)"
echo ""
echo "Now you can run: make build"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
