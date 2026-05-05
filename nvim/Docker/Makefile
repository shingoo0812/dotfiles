# ============================================================================
# Neovim Development Environment - Makefile
# ============================================================================
# Usage:
#   make build    - Build the complete Docker image
#   make save     - Save image to tar.gz file
#   make load     - Load image from tar.gz file
#   make run      - Run Neovim with mounted config
#   make open     - Open specific file or directory
#   make shell    - Run bash shell
#   make clean    - Remove Docker image
#   make help     - Show this help
# ============================================================================

# Variables
IMAGE_NAME := neovim-dev
IMAGE_TAG := latest
IMAGE_FULL := $(IMAGE_NAME):$(IMAGE_TAG)
EXPORT_FILE := $(IMAGE_NAME).tar.gz
NVIM_CONFIG := $(HOME)/dotfiles/linux/nvim
WORKSPACE := $(HOME)/projects

# Docker Hub settings (change these to your Docker Hub username)
DOCKER_USERNAME := your-dockerhub-username
DOCKER_REPO := $(DOCKER_USERNAME)/$(IMAGE_NAME)
DOCKER_REPO_FULL := $(DOCKER_REPO):$(IMAGE_TAG)

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# ============================================================================
# Main targets
# ============================================================================

.PHONY: help
help:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)  Neovim Development Environment - Makefile$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(GREEN)Build & Distribution:$(NC)"
	@echo "  make build       - Build complete Docker image"
	@echo "  make save        - Save image to $(EXPORT_FILE)"
	@echo "  make load        - Load image from $(EXPORT_FILE)"
	@echo "  make all         - Build and save (distribution package)"
	@echo "  make dist        - Create complete distribution package"
	@echo ""
	@echo "$(GREEN)Docker Hub (requires login):$(NC)"
	@echo "  make login       - Login to Docker Hub"
	@echo "  make push        - Push image to Docker Hub"
	@echo "  make pull        - Pull image from Docker Hub"
	@echo "  make publish     - Build and push to Docker Hub"
	@echo ""
	@echo "$(GREEN)Run:$(NC)"
	@echo "  make run         - Run Neovim (default workspace)"
	@echo "  make open        - Open file or directory (TARGET=path)"
	@echo "  make shell       - Run bash shell"
	@echo ""
	@echo "$(GREEN)Examples:$(NC)"
	@echo "  make open TARGET=~/projects/myapp/main.py"
	@echo "  make open TARGET=~/projects/myapp"
	@echo ""
	@echo "$(GREEN)Maintenance:$(NC)"
	@echo "  make clean       - Remove Docker image"
	@echo "  make clean-cache - Remove cache directory"
	@echo "  make clean-all   - Remove image, cache, and export file"
	@echo "  make rebuild     - Clean and rebuild"
	@echo "  make info        - Show image information"
	@echo ""
	@echo "$(GREEN)Workflow:$(NC)"
	@echo "  make check       - Check requirements"
	@echo ""

.PHONY: check
check:
	@echo "$(BLUE)Checking requirements...$(NC)"
	@command -v docker >/dev/null 2>&1 || { echo "$(RED)✗ Docker not found$(NC)"; exit 1; }
	@echo "$(GREEN)✓ Docker found: $$(docker --version)$(NC)"
	@[ -f "Dockerfile" ] || { echo "$(RED)✗ Dockerfile not found$(NC)"; exit 1; }
	@echo "$(GREEN)✓ Dockerfile found$(NC)"
	@[ -d "$(NVIM_CONFIG)" ] || { echo "$(YELLOW)⚠ Neovim config not found at $(NVIM_CONFIG)$(NC)"; }
	@echo "$(GREEN)✓ All checks passed$(NC)"

# ============================================================================
# Build targets
# ============================================================================

.PHONY: build
build: check
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)  Building $(IMAGE_FULL)...$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(YELLOW)⚠ This may take 20-30 minutes...$(NC)"
	@docker build -t $(IMAGE_FULL) .
	@echo ""
	@echo "$(GREEN)✓ Build completed successfully!$(NC)"
	@echo "$(BLUE)Image: $(IMAGE_FULL)$(NC)"
	@echo "$(BLUE)Size:  $$(docker images $(IMAGE_NAME) --format '{{.Size}}')$(NC)"

.PHONY: rebuild
rebuild: clean build

# ============================================================================
# Distribution targets
# ============================================================================

.PHONY: save
save:
	@echo "$(BLUE)Saving $(IMAGE_FULL) to $(EXPORT_FILE)...$(NC)"
	@docker save $(IMAGE_FULL) | gzip > $(EXPORT_FILE)
	@echo "$(GREEN)✓ Image saved to $(EXPORT_FILE)$(NC)"
	@echo "$(BLUE)Size: $$(du -h $(EXPORT_FILE) | cut -f1)$(NC)"
	@echo ""
	@echo "$(YELLOW)Distribution package created!$(NC)"
	@echo "Transfer $(EXPORT_FILE) to target machine and run:"
	@echo "  make load"

.PHONY: load
load:
	@if [ ! -f "$(EXPORT_FILE)" ]; then \
		echo "$(RED)✗ $(EXPORT_FILE) not found$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Loading $(EXPORT_FILE)...$(NC)"
	@docker load < $(EXPORT_FILE)
	@echo "$(GREEN)✓ Image loaded successfully!$(NC)"
	@docker images $(IMAGE_NAME)

.PHONY: all
all: build save
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)  Distribution package ready!$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "File: $(EXPORT_FILE)"
	@echo "Size: $$(du -h $(EXPORT_FILE) | cut -f1)"

# 配布用パッケージ（tar.gz + Makefile + ドキュメント）を作成
.PHONY: dist
dist: build save
	@echo "$(BLUE)Creating distribution package...$(NC)"
	@mkdir -p dist
	@cp $(EXPORT_FILE) dist/
	@cp Makefile dist/
	@cp DISTRIBUTION.md dist/README.md
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)  Distribution package created!$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "📦 Package location: dist/"
	@echo ""
	@echo "Contents:"
	@ls -lh dist/
	@echo ""
	@echo "$(YELLOW)Transfer the entire 'dist/' directory to the target machine.$(NC)"

# ============================================================================
# Docker Hub targets
# ============================================================================

.PHONY: login
login:
	@echo "$(BLUE)Logging in to Docker Hub...$(NC)"
	@if [ "$(DOCKER_USERNAME)" = "your-dockerhub-username" ]; then \
		echo "$(RED)✗ Please set DOCKER_USERNAME in Makefile first$(NC)"; \
		echo "$(YELLOW)Edit the DOCKER_USERNAME variable at the top of Makefile$(NC)"; \
		exit 1; \
	fi
	@docker login

.PHONY: push
push:
	@if [ "$(DOCKER_USERNAME)" = "your-dockerhub-username" ]; then \
		echo "$(RED)✗ Please set DOCKER_USERNAME in Makefile first$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Tagging image as $(DOCKER_REPO_FULL)...$(NC)"
	@docker tag $(IMAGE_FULL) $(DOCKER_REPO_FULL)
	@echo "$(BLUE)Pushing $(DOCKER_REPO_FULL) to Docker Hub...$(NC)"
	@echo "$(YELLOW)⚠ This may take 10-20 minutes depending on your connection...$(NC)"
	@docker push $(DOCKER_REPO_FULL)
	@echo ""
	@echo "$(GREEN)✓ Image pushed successfully!$(NC)"
	@echo "$(BLUE)Repository: $(DOCKER_REPO_FULL)$(NC)"
	@echo ""
	@echo "$(YELLOW)Users can now pull with:$(NC)"
	@echo "  docker pull $(DOCKER_REPO_FULL)"

.PHONY: pull
pull:
	@if [ "$(DOCKER_USERNAME)" = "your-dockerhub-username" ]; then \
		echo "$(RED)✗ Please set DOCKER_USERNAME in Makefile first$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Pulling $(DOCKER_REPO_FULL) from Docker Hub...$(NC)"
	@docker pull $(DOCKER_REPO_FULL)
	@echo "$(BLUE)Tagging as $(IMAGE_FULL)...$(NC)"
	@docker tag $(DOCKER_REPO_FULL) $(IMAGE_FULL)
	@echo "$(GREEN)✓ Image pulled successfully!$(NC)"
	@docker images $(IMAGE_NAME)

.PHONY: publish
publish: build push
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)  Image published to Docker Hub!$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "Repository: $(DOCKER_REPO_FULL)"
	@echo ""
	@echo "$(YELLOW)Share this command with users:$(NC)"
	@echo "  docker pull $(DOCKER_REPO_FULL)"

# ============================================================================
# Run targets
# ============================================================================

# デフォルトワークスペースでNeovimを起動
.PHONY: run
run:
	@echo "$(BLUE)Starting Neovim...$(NC)"
	@docker run -it --rm \
		-v $(NVIM_CONFIG):/root/.config/nvim \
		-v $(WORKSPACE):/workspace \
		--name neovim-dev-container \
		$(IMAGE_FULL)

# 特定のファイルまたはディレクトリを開く
.PHONY: open
open:
	@if [ -z "$(TARGET)" ]; then \
		echo "$(RED)✗ Usage: make open TARGET=path/to/file_or_dir$(NC)"; \
		echo "$(YELLOW)Examples:$(NC)"; \
		echo "  make open TARGET=~/projects/myapp/main.py"; \
		echo "  make open TARGET=~/projects/myapp"; \
		exit 1; \
	fi
	@if [ -f "$(TARGET)" ]; then \
		echo "$(BLUE)Opening file: $(TARGET)$(NC)"; \
		docker run -it --rm \
			-v $(NVIM_CONFIG):/root/.config/nvim \
			-v $$(dirname $$(realpath $(TARGET))):/workspace \
			--name neovim-dev-container \
			$(IMAGE_FULL) /workspace/$$(basename $(TARGET)); \
	elif [ -d "$(TARGET)" ]; then \
		echo "$(BLUE)Opening directory: $(TARGET)$(NC)"; \
		docker run -it --rm \
			-v $(NVIM_CONFIG):/root/.config/nvim \
			-v $$(realpath $(TARGET)):/workspace \
			--name neovim-dev-container \
			$(IMAGE_FULL); \
	else \
		echo "$(RED)✗ $(TARGET) not found$(NC)"; \
		exit 1; \
	fi

# bashシェルを起動
.PHONY: shell
shell:
	@echo "$(BLUE)Starting bash shell...$(NC)"
	@docker run -it --rm \
		-v $(NVIM_CONFIG):/root/.config/nvim \
		-v $(WORKSPACE):/workspace \
		--entrypoint /bin/bash \
		--name neovim-dev-shell \
		$(IMAGE_FULL)

# ============================================================================
# Maintenance targets
# ============================================================================

.PHONY: clean
clean:
	@echo "$(YELLOW)Removing $(IMAGE_FULL)...$(NC)"
	@docker rmi $(IMAGE_FULL) 2>/dev/null || true
	@echo "$(GREEN)✓ Cleaned$(NC)"

.PHONY: clean-cache
clean-cache:
	@echo "$(YELLOW)Removing cache directory...$(NC)"
	@rm -rf cache/
	@echo "$(GREEN)✓ Cache cleaned$(NC)"

.PHONY: clean-all
clean-all: clean clean-cache
	@echo "$(YELLOW)Removing $(EXPORT_FILE)...$(NC)"
	@rm -f $(EXPORT_FILE)
	@echo "$(YELLOW)Removing dist directory...$(NC)"
	@rm -rf dist/
	@echo "$(GREEN)✓ All cleaned$(NC)"

.PHONY: info
info:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)  Image Information$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "Image:       $(IMAGE_FULL)"
	@echo "Config:      $(NVIM_CONFIG)"
	@echo "Workspace:   $(WORKSPACE)"
	@echo "Export file: $(EXPORT_FILE)"
	@echo ""
	@docker images $(IMAGE_NAME) 2>/dev/null || echo "$(YELLOW)⚠ Image not built yet$(NC)"

# ============================================================================
# Special targets
# ============================================================================

.DEFAULT_GOAL := help

# イメージの存在チェック（内部使用）
.PHONY: .check-image
.check-image:
	@docker images -q $(IMAGE_FULL) >/dev/null 2>&1 || { \
		echo "$(RED)✗ Image $(IMAGE_FULL) not found$(NC)"; \
		echo "$(YELLOW)Run 'make build' or 'make load' first$(NC)"; \
		exit 1; \
	}

# runとshellとopenの実行前にイメージの存在チェック
run shell open: .check-image
