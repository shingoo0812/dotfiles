"""
MCP stdio bridge for the official Blender Foundation MCP extension.
Connects to Blender's socket on localhost:9876 and exposes MCP tools.
Protocol: null-byte delimited JSON over TCP.
"""
import sys
import json
import socket
import threading
import os

sys.stdout.reconfigure(line_buffering=True)
sys.stderr.reconfigure(line_buffering=True)

_LOG = open(os.path.join(os.path.dirname(__file__), "bridge.log"), "a", encoding="utf-8")
def _log(msg):
    import datetime
    _LOG.write(f"{datetime.datetime.now().isoformat()} {msg}\n")
    _LOG.flush()

_log("=== bridge started ===")

BLENDER_HOST = "localhost"
BLENDER_PORT = 9876
BLENDER_TIMEOUT = 30.0

TOOLS = [
    {
        "name": "execute_python",
        "description": "Execute Python (bpy) code in the running Blender instance. The code must set a 'result' dict variable. Example: result = {'objects': [o.name for o in bpy.context.scene.objects]}",
        "inputSchema": {
            "type": "object",
            "properties": {
                "code": {"type": "string", "description": "Python code to execute in Blender. Must assign a dict to 'result'."}
            },
            "required": ["code"]
        }
    },
    {
        "name": "get_scene_info",
        "description": "Get information about the current Blender scene (objects, camera, lights, etc.)",
        "inputSchema": {"type": "object", "properties": {}}
    }
]


def blender_execute(code: str, strict_json: bool = False) -> dict:
    request = json.dumps({"type": "execute", "code": code, "strict_json": strict_json}) + "\0"
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(BLENDER_TIMEOUT)
    try:
        sock.connect((BLENDER_HOST, BLENDER_PORT))
        sock.sendall(request.encode("utf-8"))
        buf = bytearray()
        while b"\0" not in buf:
            chunk = sock.recv(4096)
            if not chunk:
                break
            buf.extend(chunk)
        data = buf[:buf.index(b"\0")] if b"\0" in buf else buf
        return json.loads(data.decode("utf-8"))
    except Exception as e:
        return {"status": "error", "message": str(e)}
    finally:
        sock.close()


def handle_tool_call(name: str, args: dict) -> str:
    if name == "get_scene_info":
        code = """
import bpy
scene = bpy.context.scene
result = {
    "scene_name": scene.name,
    "objects": [{"name": o.name, "type": o.type, "location": list(o.location)} for o in scene.objects],
    "frame_current": scene.frame_current,
    "render_engine": scene.render.engine,
}
"""
        resp = blender_execute(code)
    elif name == "execute_python":
        code = args.get("code", "result = {}")
        resp = blender_execute(code)
    else:
        return f"Unknown tool: {name}"

    if resp.get("status") == "ok":
        return json.dumps(resp.get("result", {}), indent=2)
    else:
        return f"Error: {resp.get('message', 'Unknown error')}"


def handle_request(req: dict) -> dict | None:
    method = req.get("method", "")
    req_id = req.get("id")
    params = req.get("params", {})

    if method == "initialize":
        return {
            "jsonrpc": "2.0", "id": req_id,
            "result": {
                "protocolVersion": "2024-11-05",
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "blender-bridge", "version": "1.0.0"}
            }
        }
    if method == "notifications/initialized":
        return None
    if method == "tools/list":
        return {"jsonrpc": "2.0", "id": req_id, "result": {"tools": TOOLS}}
    if method == "tools/call":
        tool_name = params.get("name", "")
        tool_args = params.get("arguments", {})
        text = handle_tool_call(tool_name, tool_args)
        return {
            "jsonrpc": "2.0", "id": req_id,
            "result": {"content": [{"type": "text", "text": text}]}
        }
    if method == "ping":
        return {"jsonrpc": "2.0", "id": req_id, "result": {}}

    return {"jsonrpc": "2.0", "id": req_id, "error": {"code": -32601, "message": "Method not found"}}


def main():
    _log("main() started, reading stdin")
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        _log(f"recv: {line[:200]}")
        try:
            req = json.loads(line)
        except json.JSONDecodeError as e:
            _log(f"json error: {e}")
            continue
        try:
            resp = handle_request(req)
        except Exception as e:
            _log(f"handler error: {e}")
            resp = {"jsonrpc": "2.0", "id": req.get("id"), "error": {"code": -32000, "message": str(e)}}
        if resp is not None:
            out = json.dumps(resp)
            _log(f"send: {out[:200]}")
            print(out, flush=True)
    _log("stdin closed, exiting")


if __name__ == "__main__":
    main()
