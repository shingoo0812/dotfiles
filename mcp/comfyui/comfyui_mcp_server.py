"""
ComfyUI MCP Server
mcp.server.fastmcp (mcp SDK 同梱版) を使用
"""

import json
import uuid
import urllib.request
import urllib.parse
import re
from pathlib import Path

from mcp.server.fastmcp import FastMCP

BASE_URL     = "http://localhost:8188"
WORKFLOW_DIR = Path("G:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/user/default/workflows")
LOG_FILE     = Path("G:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/user/comfyui.log")

mcp = FastMCP("comfyui")


# ── 内部ユーティリティ ──────────────────────────────────────────────

def _get(path: str) -> dict:
    with urllib.request.urlopen(f"{BASE_URL}{path}", timeout=15) as r:
        return json.loads(r.read())

def _post(path: str, data: dict) -> dict:
    body = json.dumps(data).encode()
    req  = urllib.request.Request(
        f"{BASE_URL}{path}", data=body,
        headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.loads(r.read())

def _running() -> bool:
    try:
        urllib.request.urlopen(f"{BASE_URL}/system_stats", timeout=3)
        return True
    except Exception:
        return False


# ── ツール ──────────────────────────────────────────────────────────

@mcp.tool()
def comfyui_stats() -> str:
    """ComfyUI のシステム状態・GPU / VRAM 情報を返す"""
    if not _running():
        return "ComfyUI が起動していません（localhost:8188）"
    s   = _get("/system_stats")
    sys_ = s["system"]
    dev  = s["devices"][0] if s.get("devices") else {}
    return (
        f"ComfyUI {sys_['comfyui_version']}  |  PyTorch {sys_['pytorch_version']}\n"
        f"GPU : {dev.get('name', 'N/A')}\n"
        f"VRAM: {dev.get('vram_free',0)//1024//1024} MB free / {dev.get('vram_total',0)//1024//1024} MB total\n"
        f"RAM : {sys_['ram_free']//1024//1024} MB free / {sys_['ram_total']//1024//1024} MB total"
    )


@mcp.tool()
def comfyui_queue() -> str:
    """現在のキュー状態（実行中・待機中の件数）を返す"""
    if not _running():
        return "ComfyUI が起動していません"
    q = _get("/queue")
    running = q.get("queue_running", [])
    pending = q.get("queue_pending", [])
    lines = [f"実行中: {len(running)}  待機中: {len(pending)}"]
    for item in running:
        lines.append(f"  [実行中] {str(item[1])[:12] if len(item) > 1 else '?'}")
    for item in pending[:5]:
        lines.append(f"  [待機]   {str(item[1])[:12] if len(item) > 1 else '?'}")
    return "\n".join(lines)


@mcp.tool()
def comfyui_search_nodes(query: str) -> str:
    """
    利用可能なノードをキーワード検索する。
    query: 検索キーワード（例: KSampler, ControlNet, CLIP）
    """
    if not _running():
        return "ComfyUI が起動していません"
    with urllib.request.urlopen(f"{BASE_URL}/object_info", timeout=30) as r:
        raw = r.read().decode()
    all_keys = list(dict.fromkeys(re.findall(r'"([^"]+)":\s*\{', raw)))
    matched  = [k for k in all_keys if query.lower() in k.lower()]
    if not matched:
        return f"'{query}' に一致するノードは見つかりませんでした"
    return f"{len(matched)} 件:\n" + "\n".join(f"  {k}" for k in matched[:50])


@mcp.tool()
def comfyui_node_info(node_name: str) -> str:
    """
    指定ノードの入出力定義・パラメータを返す。
    node_name: ノード名（例: KSampler, CLIPTextEncode）
    """
    if not _running():
        return "ComfyUI が起動していません"
    try:
        url = f"{BASE_URL}/object_info/{urllib.parse.quote(node_name)}"
        with urllib.request.urlopen(url, timeout=10) as r:
            data = json.loads(r.read())
        return json.dumps(data, ensure_ascii=False, indent=2)[:4000]
    except Exception as e:
        return f"エラー: {e}"


@mcp.tool()
def comfyui_list_workflows(subfolder: str = "") -> str:
    """
    保存済みワークフローの一覧を返す。
    subfolder: サブフォルダ名でフィルタ（省略時は全件）
    """
    base = WORKFLOW_DIR / subfolder if subfolder else WORKFLOW_DIR
    if not base.exists():
        return f"フォルダが存在しません: {base}"
    files = sorted(base.rglob("*.json"))
    if not files:
        return "ワークフローが見つかりません"
    lines = [str(f.relative_to(WORKFLOW_DIR)) for f in files]
    return f"{len(lines)} 件:\n" + "\n".join(f"  {l}" for l in lines[:100])


@mcp.tool()
def comfyui_load_workflow(path: str) -> str:
    """
    ワークフロー JSON を読み込んで返す。
    path: WORKFLOW_DIR からの相対パス（例: T2I/my_workflow.json）または絶対パス
    """
    p = Path(path) if Path(path).is_absolute() else WORKFLOW_DIR / path
    if not p.exists():
        return f"ファイルが存在しません: {p}"
    content = p.read_text(encoding="utf-8")
    if len(content) > 8000:
        data = json.loads(content)
        nc   = len(data) if isinstance(data, dict) else "?"
        return f"ファイル: {p}\nノード数: {nc}\n\n--- JSON（先頭8000文字）---\n{content[:8000]}"
    return f"ファイル: {p}\n\n{content}"


@mcp.tool()
def comfyui_save_workflow(path: str, content: str) -> str:
    """
    ワークフロー JSON を保存する。
    path: 保存先（WORKFLOW_DIR からの相対パス または絶対パス）
    content: 保存する JSON 文字列
    """
    p = Path(path) if Path(path).is_absolute() else WORKFLOW_DIR / path
    try:
        json.loads(content)
    except json.JSONDecodeError as e:
        return f"JSON が不正です: {e}"
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(content, encoding="utf-8")
    return f"保存しました: {p}"


@mcp.tool()
def comfyui_submit_workflow(workflow_json: str) -> str:
    """
    ワークフローをキューに投入して実行する。prompt_id を返す。
    workflow_json: ComfyUI prompt 形式の JSON 文字列（ノードIDをキーとする dict）
    """
    if not _running():
        return "ComfyUI が起動していません"
    try:
        workflow = json.loads(workflow_json)
    except json.JSONDecodeError as e:
        return f"JSON が不正です: {e}"
    client_id = str(uuid.uuid4())
    result    = _post("/prompt", {"prompt": workflow, "client_id": client_id})
    if "error" in result:
        return f"エラー: {json.dumps(result, ensure_ascii=False, indent=2)}"
    return f"キューに投入しました\nprompt_id: {result.get('prompt_id','')}"


@mcp.tool()
def comfyui_get_history(limit: int = 5) -> str:
    """
    実行履歴を返す。
    limit: 取得件数（デフォルト 5）
    """
    if not _running():
        return "ComfyUI が起動していません"
    data = _get(f"/history?max_items={limit}")
    if not data:
        return "履歴がありません"
    lines = []
    for pid, v in list(data.items())[:limit]:
        status    = v.get("status", {}).get("status_str", "?")
        completed = v.get("status", {}).get("completed", False)
        out_count = sum(
            len(n.get("images", [])) + len(n.get("gifs", []))
            for n in v.get("outputs", {}).values()
        )
        lines.append(f"  {pid[:12]}  status={status}  completed={completed}  出力={out_count}件")
    return f"直近 {len(lines)} 件:\n" + "\n".join(lines)


@mcp.tool()
def comfyui_get_outputs(prompt_id: str) -> str:
    """
    指定 prompt_id の出力ファイル URL を返す。
    prompt_id: submit_workflow で返された ID
    """
    if not _running():
        return "ComfyUI が起動していません"
    hist = _get(f"/history/{prompt_id}")
    if prompt_id not in hist:
        return f"'{prompt_id}' が見つかりません（実行中または存在しない）"
    urls = []
    for node_out in hist[prompt_id].get("outputs", {}).values():
        for img in node_out.get("images", []):
            urls.append(
                f"{BASE_URL}/view?filename={img['filename']}"
                f"&subfolder={img.get('subfolder','')}&type={img.get('type','output')}")
        for vid in node_out.get("gifs", []):
            urls.append(
                f"{BASE_URL}/view?filename={vid['filename']}"
                f"&subfolder={vid.get('subfolder','')}&type={vid.get('type','output')}")
    if not urls:
        return "出力ファイルがありません（実行中かもしれません）"
    return f"{len(urls)} 件:\n" + "\n".join(f"  {u}" for u in urls)


@mcp.tool()
def comfyui_get_log(lines: int = 80) -> str:
    """
    ComfyUI ログの末尾を返す。
    lines: 取得行数（デフォルト 80）
    """
    if not LOG_FILE.exists():
        return f"ログが見つかりません: {LOG_FILE}"
    with open(LOG_FILE, encoding="utf-8", errors="replace") as f:
        all_lines = f.readlines()
    return f"【末尾 {lines} 行 / 全 {len(all_lines)} 行】\n" + "".join(all_lines[-lines:])


@mcp.tool()
def comfyui_get_errors() -> str:
    """
    ログから ERROR / Traceback / IMPORT FAILED を抽出する。
    ノードのロード失敗やランタイムエラーの調査に使う。
    """
    if not LOG_FILE.exists():
        return f"ログが見つかりません: {LOG_FILE}"
    pat = re.compile(r"ERROR|Traceback|IMPORT FAILED|ImportError|ModuleNotFoundError", re.IGNORECASE)
    with open(LOG_FILE, encoding="utf-8", errors="replace") as f:
        all_lines = f.readlines()
    blocks, seen = [], set()
    for i, line in enumerate(all_lines):
        if pat.search(line):
            start = max(0, i - 2)
            end   = min(len(all_lines), i + 5)
            block = "".join(all_lines[start:end]).strip()
            key   = block[:100]
            if key not in seen:
                seen.add(key)
                blocks.append(block)
    if not blocks:
        return "エラーは見つかりませんでした"
    return f"{len(blocks)} 件（重複除去済み）:\n\n" + "\n\n---\n\n".join(blocks[:20])


@mcp.tool()
def comfyui_interrupt() -> str:
    """現在実行中の生成を中断する"""
    if not _running():
        return "ComfyUI が起動していません"
    _post("/interrupt", {})
    return "中断しました"


@mcp.tool()
def comfyui_free_memory(unload_models: bool = False, free_memory: bool = True) -> str:
    """
    GPU / CPU メモリを解放する。
    unload_models: True でモデルもアンロード（次回生成時に再ロードが必要）
    free_memory: True でキャッシュを解放（デフォルト True）
    """
    if not _running():
        return "ComfyUI が起動していません"
    _post("/free", {"unload_models": unload_models, "free_memory": free_memory})
    s   = _get("/system_stats")
    dev = s["devices"][0] if s.get("devices") else {}
    return f"解放しました\nVRAM free: {dev.get('vram_free',0)//1024//1024} MB"


if __name__ == "__main__":
    mcp.run()
