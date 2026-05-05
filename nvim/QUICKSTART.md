# 🚀 SHINGOさん用クイックスタートガイド

## 📦 含まれているファイル

1. `Dockerfile` - Neovim開発環境の定義
2. `docker-compose.yml` - コンテナオーケストレーション設定
3. `.env.example` - 環境変数のテンプレート
4. `.dockerignore` - ビルドから除外するファイル
5. `Makefile` - 便利なコマンドショートカット
6. `README.md` - 詳細なドキュメント

## ⚡ Windows環境での最速セットアップ

### 1. ファイルの展開
```bash
# ダウンロードしたファイルを展開
cd ~
mkdir neovim-docker
cd neovim-docker
# neovim-docker-config.tar.gz を展開
tar xzf neovim-docker-config.tar.gz
```

### 2. 環境変数の設定（Windows）
```bash
# .envファイルを作成
cp .env.example .env

# .envを編集（メモ帳またはNeovimで）
notepad .env

# 以下のように設定
NVIM_CONFIG_PATH=C:/Users/shing/AppData/Local/nvim
WORKSPACE_PATH=C:/Users/shing/projects
```

### 3. ビルドと起動
```bash
# イメージをビルド（初回のみ、5-10分）
docker-compose build

# Neovimを起動
docker-compose run --rm neovim

# または、Makefileを使う場合
make install  # 初回のみ
make nvim     # Neovimを起動
```

## 🎯 よく使うコマンド

### Makefileを使う場合（推奨）
```bash
make nvim           # Neovimを起動
make shell          # シェルを開く
make open FILE=test.py  # 特定のファイルを開く
make update         # プラグインを更新
make clean          # 全削除（再構築用）
```

### docker-composeを直接使う場合
```bash
# Neovimを起動
docker-compose run --rm neovim

# 特定のファイルを開く
docker-compose run --rm neovim /workspace/myproject/main.py

# シェルを開く
docker-compose run --rm shell

# コンテナを停止
docker-compose down
```

## 🔧 SHINGOさんの環境向けカスタマイズ

### プラグイン設定の確認
初回起動時、Lazy.nvimが自動的に以下をインストールします：
- Copilot / CopilotChat
- Telescope
- Neo-tree
- LSP設定（Mason経由）
- DAP（デバッガー）
- その他58個のプラグイン

### 追加でインストールしたいLSPがある場合
コンテナ内で：
```vim
:Mason
```
または、Dockerfileに追加して再ビルド。

### Houdini関連の開発環境
Houdini用のPython環境が必要な場合、Dockerfileに追加：
```dockerfile
# Houdini Python packages
RUN pip3 install --no-cache-dir --break-system-packages \
    hou \
    numpy \
    scipy
```

## 🐛 トラブルシューティング

### Windowsでのパス問題
Windowsのパスは必ず `/` を使用：
```
❌ C:\Users\shing\AppData\Local\nvim
✅ C:/Users/shing/AppData/Local/nvim
```

### WSL2との併用
WSL2を使っている場合、WSL内から起動することを推奨：
```bash
# WSL2のターミナルから
cd /mnt/c/Users/shing/neovim-docker
docker-compose run --rm neovim
```

### プラグインが見つからない
```bash
# コンテナ内で手動インストール
docker-compose run --rm neovim
# Neovim内で
:Lazy sync
:Mason
```

### 設定ファイルが反映されない
```bash
# マウントを確認
docker-compose config

# 設定ファイルパスが正しいか確認
docker-compose run --rm shell
ls -la /root/.config/nvim
```

## 📚 次のステップ

1. **エイリアスの設定**（PowerShellの場合）
```powershell
# $PROFILE に追加
function dnvim { docker-compose -f C:/Users/shing/neovim-docker/docker-compose.yml run --rm neovim $args }
function dnvim-shell { docker-compose -f C:/Users/shing/neovim-docker/docker-compose.yml run --rm shell }

# 使用例
dnvim myfile.py
```

2. **dotfilesリポジトリへの追加**
```bash
cd ~/dotfiles
cp -r ~/neovim-docker ./
git add neovim-docker
git commit -m "Add Neovim Docker environment"
git push
```

3. **他の環境での使用**
別のマシンでは：
```bash
git clone <your-dotfiles-repo>
cd dotfiles/neovim-docker
make install
make nvim
```

## 🎨 カスタマイズのヒント

### C#開発の追加
```dockerfile
# Dockerfile に追加
RUN wget https://dot.net/v1/dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh --channel 8.0 && \
    rm dotnet-install.sh
```

### データベース開発の追加
```yaml
# docker-compose.yml に追加
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
```

## ✅ チェックリスト

- [ ] Docker Desktopがインストール済み
- [ ] `.env`ファイルを作成し、パスを設定
- [ ] `docker-compose build` でイメージをビルド
- [ ] `docker-compose run --rm neovim` でNeovimが起動
- [ ] プラグインが正常にロード
- [ ] LSPが動作している（`:LspInfo`で確認）

---

**質問や問題があれば、README.mdの詳細ドキュメントを参照してください！**
