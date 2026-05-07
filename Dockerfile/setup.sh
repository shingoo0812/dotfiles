#!/bin/bash
# Neovim Docker setup script
# Run this script in WSL
DOCKERFILE_DIR="$HOME/dotfiles/Dockerfile"
# Build image
echo "Building Docker image..."
cd "$DOCKERFILE_DIR"
docker compose build
# Add nvim function to zshrc
echo ""
echo "Adding nvim function to ~/.zshrc..."
cat >> ~/.zshrc << 'ZSHRC_EOF'
# Docker Neovim
nvim() {
    docker run --rm -it \
        -v "$(pwd):/workspace" \
        -w /workspace \
        dotfiles-nvim \
        nvim "$@"
}
ZSHRC_EOF
echo ""
echo "✅ Setup complete!"
echo ""
echo "Run: source ~/.zshrc"
echo "Then: nvim <file>"