# ComfyUI MCP Server

Claude Code から ComfyUI を直接操作するための MCP サーバー。

## セットアップ

### 登録方法

`claude mcp add` コマンドで登録する（`claude_desktop_config.json` や `settings.json` の `mcpServers` では **読み込まれない**）。

```bash
claude mcp add comfyui "C:/Users/shingo/miniconda3/python.exe" \
  "C:/Users/shingo/AppData/Local/dotfiles/comfyui-mcp/comfyui_mcp_server.py"
```

登録先は `~/.claude.json`（プロジェクトスコープ）。

### 確認

```bash
claude mcp list
# comfyui: ... - ✓ Connected
```

---

## 利用可能なツール（14個）

| ツール | 説明 |
|---|---|
| `comfyui_stats` | GPU / VRAM / RAM 状態を表示 |
| `comfyui_queue` | 実行キューの状態（実行中・待機中件数） |
| `comfyui_search_nodes` | ノードをキーワード検索 |
| `comfyui_node_info` | 指定ノードの入出力定義を取得 |
| `comfyui_list_workflows` | 保存済みワークフロー一覧 |
| `comfyui_load_workflow` | ワークフロー JSON を読み込む |
| `comfyui_save_workflow` | ワークフロー JSON を保存 |
| `comfyui_submit_workflow` | ワークフローをキューに投入して実行 |
| `comfyui_get_history` | 実行履歴を取得 |
| `comfyui_get_outputs` | 指定 prompt_id の出力ファイル URL |
| `comfyui_get_log` | ComfyUI ログの末尾を取得 |
| `comfyui_get_errors` | ログから ERROR / Traceback を抽出 |
| `comfyui_interrupt` | 実行中の生成を中断 |
| `comfyui_free_memory` | GPU / CPU メモリを解放 |

---

## ワークフロー作成の注意点

### UI 保存形式 vs API 実行形式

**`comfyui_save_workflow`** → UI 形式（LiteGraph JSON）で保存。ComfyUI ブラウザで開ける。

**`comfyui_submit_workflow`** → API prompt 形式（ノードIDをキーとする辞書）で実行。

```python
# API 形式の例
{
  "1": {"class_type": "CheckpointLoaderSimple", "inputs": {"ckpt_name": "..."}},
  "2": {"class_type": "CLIPTextEncode",         "inputs": {"clip": ["1", 1], "text": "..."}},
  ...
}
```

### ワークフロー作成のベストプラクティス

UI 形式のワークフローを一から作るとリンクがずれやすい。
**既存ワークフローを `comfyui_load_workflow` で読み込み、Python で改変して保存する**のが確実。

```python
import json
with open("既存.json") as f:
    wf = json.load(f)
# widgets_values だけ書き換える
for node in wf["nodes"]:
    if node["type"] == "CheckpointLoaderSimple":
        node["widgets_values"] = ["sdxl\\juggernautXL_v9...safetensors"]
with open("新規.json", "w") as f:
    json.dump(wf, f, ensure_ascii=False, indent=2)
```

---

## 設定値

```python
BASE_URL     = "http://localhost:8188"
WORKFLOW_DIR = "G:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/user/default/workflows"
LOG_FILE     = "G:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/user/comfyui.log"
```

---

## 注意点

- **ComfyUI が起動していない場合**、各ツールは `"ComfyUI が起動していません"` を返す（クラッシュしない）
- サーバー自体は ComfyUI の起動有無に関わらず常時動作する
- `comfyui_search_nodes` は `/object_info` を全件取得するため、**初回は数秒かかる**
- `comfyui_submit_workflow` は非同期。完了確認は `comfyui_get_history` または `comfyui_queue` で行う
- ログファイルが存在しない場合、`comfyui_get_log` / `comfyui_get_errors` はエラーメッセージを返す
- Python 環境: `C:/Users/shingo/miniconda3/python.exe`（mcp 1.27.1）

---

## トラブルシューティング

### ツールが Claude Code に表示されない

`settings.json` や `claude_desktop_config.json` の `mcpServers` **ではなく**、必ず `claude mcp add` で登録すること。

### 接続確認

```bash
claude mcp list   # ✓ Connected を確認
```

登録後は Claude Code の**再起動が必要**（セッション起動時にのみ MCP サーバーが接続される）。
