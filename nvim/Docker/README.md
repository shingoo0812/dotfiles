# Neovim Development Environment - Docker

完全にセットアップ済みのNeovim開発環境をDockerで提供します。ネットワーク接続が不安定な環境でも安定してビルド・使用できるように、ホストシステムから直接コピーする方式を採用しています。

## 📦 特徴

- ✅ **オフライン対応** - ビルド後はネットワーク不要
- ✅ **完全な開発環境** - Python, Node.js, Go, Rust すべて含む
- ✅ **既存設定を活用** - あなたのNeovim設定をそのまま使用
- ✅ **高速ビルド** - ホストからコピーするため超高速
- ✅ **簡単配布** - Docker Hubまたはtar.gz形式で配布可能

## 🛠️ 含まれるツール

| カテゴリ | ツール |
|---------|--------|
| **エディタ** | Neovim (最新版) |
| **言語ランタイム** | Python 3.x, Node.js 20.x, Go 1.23.4, Rust (latest) |
| **検索ツール** | ripgrep, fd, fzf |
| **バージョン管理** | Git, LazyGit |
| **ビルドツール** | gcc, g++, clang, cmake, ninja |
| **Python** | pip, venv, pynvim |
| **その他** | curl, wget, unzip, tar, sqlite3, postgresql-client |

**注意:** LSPサーバーやフォーマッターはDockerイメージには含まれていません。Neovim内で`:Mason`を実行してインストールしてください。

## 📋 前提条件

- Docker 20.10以降
- ディスク空き容量: 5GB以上
- メモリ: 2GB以上推奨
- OS: Linux, macOS, Windows (WSL2)

## 🚀 クイックスタート

### 方法1: Docker Hub から取得（推奨）

```bash
# 1. このリポジトリをクローン（Makefileが必要）
git clone https://your-repo/neovim-docker.git
cd neovim-docker

# 2. Makefileを編集（パスとユーザー名を設定）
vim Makefile
# DOCKER_USERNAME を設定
# NVIM_CONFIG を設定（あなたのNeovim設定パス）
# WORKSPACE を設定（作業ディレクトリ）

# 3. イメージをプル
make pull

# 4. 実行
make run
```

### 方法2: ローカルでビルド

```bash
# 1. キャッシュを準備（ホストシステムから）
./prepare-cache.sh

# 2. ビルド
make build

# 3. 実行
make run
```

## 📖 詳細な使い方

### 初回セットアップ

#### 1. キャッシュの準備

```bash
# 実行権限を付与
chmod +x prepare-cache.sh

# スクリプトを実行（自動検出）
./prepare-cache.sh

# 以下がcache/ディレクトリにコピーされます：
# - Neovimバイナリ
# - Neovimプラグイン（~/.local/share/nvim）
# - Go（オプション）
# - LazyGit（オプション）
```

#### 2. Makefileの設定

```makefile
# Makefileの変数セクション（15-20行目あたり）を編集

# Docker Hub用（配布する場合）
DOCKER_USERNAME := your-dockerhub-username  # ← あなたのDocker Hubユーザー名

# ローカルパス
NVIM_CONFIG := $(HOME)/dotfiles/linux/nvim  # ← あなたのNeovim設定
WORKSPACE := $(HOME)/projects                # ← 作業ディレクトリ
```

#### 3. ビルド

```bash
# 事前チェック
make check

# ビルド実行（20-30分かかります）
make build
```

### 基本的な使い方

```bash
# ヘルプを表示
make help

# デフォルトワークスペースでNeovimを起動
make run

# 特定のファイルを開く
make open TARGET=~/projects/myapp/main.py

# 特定のディレクトリを開く
make open TARGET=~/projects/myapp

# Bashシェルを起動（デバッグ用）
make shell
```

## 📤 配布方法

### Docker Hub経由（推奨）

#### アップロード側

```bash
# 1. Docker Hubにログイン
make login

# 2. ビルドしてプッシュ
make publish

# または個別に
make build
make push
```

#### ダウンロード側

```bash
# 1. Makefileを取得
wget https://your-repo/Makefile

# 2. DOCKER_USERNAMEを編集
vim Makefile

# 3. イメージをプル
make pull

# 4. 使用
make run
```

### tar.gz形式（オフライン配布）

#### 配布パッケージの作成

```bash
# 完全な配布パッケージを作成
make dist

# 作成されるもの：
# dist/
# ├── neovim-dev.tar.gz  # Dockerイメージ（2-3GB）
# ├── Makefile           # 実行用Makefile
# └── README.md          # 使用方法

# 配布用に圧縮（オプション）
tar czf neovim-dev-package.tar.gz dist/
```

#### 配布パッケージの使用

```bash
# 1. パッケージを展開
tar xzf neovim-dev-package.tar.gz
cd dist/

# 2. イメージをロード
docker load < neovim-dev.tar.gz

# 3. Makefileを編集
vim Makefile
# NVIM_CONFIG と WORKSPACE を設定

# 4. 実行
make run
```

## 🔧 トラブルシューティング

### ビルドが失敗する

```bash
# キャッシュを確認
ls -lh cache/

# Dockerログを確認
docker build -t neovim-dev:latest . 2>&1 | tee build.log

# キャッシュを再作成
./prepare-cache.sh
```

### Neovim設定が反映されない

```bash
# 設定パスを確認
ls -la ~/dotfiles/linux/nvim/
ls -la ~/.config/nvim/

# Makefileのパスを修正
vim Makefile
# NVIM_CONFIG := /正しい/パス/に/変更
```

### コンテナが起動しない

```bash
# イメージの存在を確認
docker images neovim-dev

# イメージをリビルド
make rebuild

# ログを確認
make shell
```

### ファイルが開けない

```bash
# パスの確認
make open TARGET=/absolute/path/to/file.py

# または相対パスで
cd /path/to/project
make open TARGET=./file.py
```

### Docker Hubにプッシュできない

```bash
# ログインを確認
docker login

# ユーザー名を確認
vim Makefile
# DOCKER_USERNAME が正しいか確認

# 再度プッシュ
make push
```

## 📁 プロジェクト構造

```
neovim-docker/
├── Dockerfile              # Dockerイメージ定義
├── Makefile               # ビルド/実行コマンド
├── prepare-cache.sh       # キャッシュ準備スクリプト
├── README.md              # このファイル
├── DISTRIBUTION.md        # 配布パッケージ用の説明書
└── cache/                 # ビルド時に使用（.gitignoreに追加推奨）
    ├── nvim-linux64/      # Neovimバイナリ
    ├── nvim-data/         # プラグインとデータ
    ├── go*.tar.gz         # Go言語（オプション）
    └── lazygit*.tar.gz    # LazyGit（オプション）
```

## 🧹 メンテナンス

```bash
# イメージを削除
make clean

# キャッシュを削除
make clean-cache

# すべて削除（イメージ + キャッシュ + エクスポートファイル）
make clean-all

# 再ビルド
make rebuild

# イメージ情報を表示
make info
```

## 📚 コマンド一覧

### ビルド・配布

| コマンド | 説明 |
|---------|------|
| `make build` | Dockerイメージをビルド |
| `make save` | イメージをtar.gz形式で保存 |
| `make load` | tar.gzからイメージをロード |
| `make all` | ビルド + 保存 |
| `make dist` | 完全な配布パッケージを作成 |

### Docker Hub

| コマンド | 説明 |
|---------|------|
| `make login` | Docker Hubにログイン |
| `make push` | イメージをDocker Hubにプッシュ |
| `make pull` | イメージをDocker Hubからプル |
| `make publish` | ビルド + プッシュ |

### 実行

| コマンド | 説明 |
|---------|------|
| `make run` | Neovimを起動（デフォルトワークスペース） |
| `make open TARGET=<path>` | 特定のファイル/ディレクトリを開く |
| `make shell` | Bashシェルを起動 |

### メンテナンス

| コマンド | 説明 |
|---------|------|
| `make clean` | イメージを削除 |
| `make clean-cache` | キャッシュを削除 |
| `make clean-all` | すべて削除 |
| `make rebuild` | 再ビルド |
| `make info` | イメージ情報を表示 |
| `make check` | 前提条件をチェック |
| `make help` | ヘルプを表示 |

## 🔒 セキュリティ注意事項

- コンテナは`root`ユーザーで実行されます
- ホストのディレクトリをマウントする際は権限に注意してください
- プライベートなファイル（SSH鍵など）をマウントする場合は`:ro`（読み取り専用）を使用してください

## 🌟 カスタマイズ

### 追加のツールをインストール

```dockerfile
# Dockerfileに追加
RUN apt-get update && apt-get install -y \
    your-package-here \
    && rm -rf /var/lib/apt/lists/*
```

### 環境変数の設定

```bash
# docker-compose.ymlを作成（オプション）
# または Makefileのrunターゲットに追加
-e YOUR_ENV_VAR=value
```

### 別のワークスペースをマウント

```bash
# Makefileを編集
WORKSPACE := /your/custom/path

# または一時的に
WORKSPACE=/tmp/myproject make run
```

## 💡 ヒント

- **初回起動時**: `:Mason`でLSPサーバーをインストール
- **プラグイン更新**: `:Lazy sync`
- **設定の同期**: ホストの設定を変更すると自動的に反映されます
- **複数バージョン**: `IMAGE_TAG`を変更して複数バージョンを管理可能

## 🤝 コントリビューション

改善提案やバグ報告は歓迎します！

## 📄 ライセンス

このプロジェクトは自由に使用・改変できます。

## 👤 作成者

**SHINGO**

- 技術スタック: Houdini, Python, VEX, C#, Unity
- 専門: 3D開発環境、プロシージャルワークフロー

## 🔗 関連リンク

- [Neovim](https://neovim.io/)
- [Docker](https://www.docker.com/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)

---

**バージョン:** 1.0  
**更新日:** 2024-11-24  
**ビルド時間:** 約20-30分（初回のみ）  
**イメージサイズ:** 約2-3GB
