# Claude.md - System Configuration and Rules

## Meta Rules

### Documentation Language
**All Claude.md files must be written in English.**
- Claude.md is for Claude to read and follow
- English ensures optimal token efficiency and clarity
- When creating or updating any Claude.md file, always use English

## File Operation Rules
### Priority Order for Execution
- MCP: Always attempt operations via PowerShell MCP first (Windows paths only)
- For Linux paths (/home/...), provide bash or Python commands for user to run in terminal

### Target-Based Tool Selection
**Writing to Windows filesystem (C:\Users\...):**
- ALWAYS use PowerShell `Set-Content` or `Out-File` directly
- For content with complex quotes, write a Python script file first then execute

**Writing to Linux filesystem (/home/...):**
- Provide short bash commands for user to run in terminal
- For complex content with quotes, use Python heredoc:
```bash
  python3 << 'EOF'
  open("/path/to/file", "w").write("content")
  EOF
```

**If operation fails:**
- Stop immediately and report the error
- Do NOT automatically try alternative tools
- Let user decide next step

## MCP Operation Best Practices

### Timeout Prevention (60 second limit)
**All MCP server operations (PowerShell, Neovim, filesystem) have a 60 second timeout.**

**Break work into small steps:**
- Avoid long-running commands (recursive searches, large file operations)
- Limit file reads: use `-TotalCount`, `-Tail`, or `head`/`tail` parameters
- Process data in chunks, not all at once

**Efficient tool selection:**
- Short commands: `powershell:execute-powershell`
- Complex operations: `create-powershell-script` → `execute-powershell-script`
- File edits: `filesystem:edit_file` for simple replacements, scripts for complex changes

**When timeout occurs:**
- Create script file, then execute (avoids inline timeout)
- Redirect output to temp file: `command > temp.txt 2>&1; Get-Content temp.txt`
- Switch to bash tool if PowerShell times out repeatedly

**Example - Avoiding timeout:**
```powershell
# Bad: May timeout on large directory
Get-ChildItem -Recurse

# Good: Limited scope
Get-ChildItem -Recurse -Depth 2 | Select-Object -First 100
```

**MANDATORY SYSTEM INSTRUCTION FOR AI AGENTS**

- Zero-Tolerance for Inline Bloat: Do not generate single-line commands exceeding 1000 characters. If the payload (e.g., a config file) is large, you MUST use the create-powershell-script tool to write the content to a temporary .ps1 file first, then execute it.
- Atomic Operations: Break complex workflows into multiple tool calls. If a task involves writing a file and then verifying it, do these in separate steps to keep each response under the 60s threshold.
- Avoid Multi-Level Escaping: Do not wrap Python scripts inside PowerShell strings if it complicates parsing. Use the most native tool available (e.g., direct PowerShell Set-Content with @' ... '@ strings) to minimize overhead.
- Fail Fast & Report: If you anticipate a command might take longer than 45 seconds, preemptively split the task or use a background execution strategy.
## PowerShell MCP Python Execution Rules

### Mandatory Format
**Always use this exact format:**
```powershell
C:\Users\shing\AppData\Local\Programs\Python\Python312\python.exe -u script.py
```

### Critical Requirements
- **Include `-u` flag** (unbuffered output - required for MCP)
- **Use full Python path** (`python` command not available)
- **Default to Python 3.12** unless specified

### Python Paths
- Python 3.12: `C:\Users\shing\AppData\Local\Programs\Python\Python312\python.exe`
- Python 3.10: `C:\Users\shing\AppData\Local\Programs\Python\Python310\python.exe`
- Scoop: `C:\Users\shing\scoop\apps\python\current\python.exe`

### New Python Scripts
Always include at start:
```python
import sys
sys.stdout.reconfigure(line_buffering=True)
sys.stderr.reconfigure(line_buffering=True)
```

### Troubleshooting No Output
1. Redirect to file:
```powershell
python.exe -u script.py > output.txt 2>&1
Get-Content output.txt
```

2. Switch to bash if PowerShell MCP fails

### Prohibited
- Never use `python` directly (PATH not inherited in MCP)
- Never omit `-u` flag (output will be buffered/lost)
