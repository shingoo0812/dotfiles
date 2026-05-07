#!/bin/bash
set -e
DOCKERFILE_DIR="$HOME/dotfiles/Dockerfile"
echo "Building complete Neovim Docker environment..."
cd "$DOCKERFILE_DIR"
# Build
docker compose build --no-cache
# Start
docker compose up -d
# Add nvim wrapper
if ! grep -q "# Docker Neovim" ~/.zshrc 2>/dev/null; then
    cat >> ~/.zshrc << 'WRAPPER'
# Docker Neovim
nvim() {
    docker run --rm -it \
        -v "$(pwd):/workspace" \
        -w /workspace \
        dotfiles-nvim \
        nvim "$@"
}
WRAPPER
fi
echo ""
echo "✅ Setup complete!"
echo ""
echo "Run: source ~/.zshrc"
echo "Then: nvim <file>"