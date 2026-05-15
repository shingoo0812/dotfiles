================================================================
 Ollama MCP Agent
================================================================

REQUIREMENTS
------------
- Ollama installed and running (https://ollama.com)
- Python: C:\Users\shingo\miniconda3\python.exe
- At least one Ollama model that supports tool calling


INSTALL DEPENDENCIES (first time only)
---------------------------------------
  cd C:\Users\shingo\Documents\MCP\ollama-mcp
  C:\Users\shingo\miniconda3\python.exe -m pip install -r requirements.txt


PULL A MODEL (if you haven't already)
--------------------------------------
  ollama pull llama3.2        (small, fast)
  ollama pull qwen2.5         (good tool calling)
  ollama pull mistral

  Check installed models:
  ollama list


================================================================
 PART 1 — CLI Chat Agent
================================================================

Run the agent:
  C:\Users\shingo\miniconda3\python.exe agent.py
  C:\Users\shingo\miniconda3\python.exe agent.py --model qwen3.5:35b
  C:\Users\shingo\miniconda3\python.exe agent.py --model mistral

The agent can:
  - Read and write local files   (read_file, write_file)
  - List directories             (list_directory)
  - Run shell commands           (run_shell)

Type "quit" or press Ctrl+C to exit.

Models confirmed to support tool calling:
  llama3.1, llama3.2, mistral, qwen2.5, qwen2.5-coder,
  qwen3 (any size), command-r


================================================================
 PART 2 — Ollama as an MCP Server (for Claude Desktop)
================================================================

This lets Claude Desktop call your local Ollama models as tools.

1. Open (or create) the Claude Desktop config file:
   %AppData%\Claude\claude_desktop_config.json

2. Add the following:

   {
     "mcpServers": {
       "ollama": {
         "command": "C:/Users/shingo/miniconda3/python.exe",
         "args": ["C:/Users/shingo/Documents/MCP/ollama-mcp/ollama_server.py"]
       }
     }
   }

3. Restart Claude Desktop.

Claude will then have two new tools:
  - ollama_chat(prompt, model, system)   — chat with a local model
  - ollama_list_models()                 — list installed models


================================================================
 FILES
================================================================

  agent.py             CLI agent (Ollama LLM + MCP tools)
  filesystem_server.py MCP server exposing file + shell tools
  ollama_server.py     MCP server wrapping Ollama inference
  requirements.txt     Python dependencies
  README.txt           This file
