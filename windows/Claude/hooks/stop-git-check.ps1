# Stop hook: auto-commit changed repos + remind about CLAUDE.md if needed
$ErrorActionPreference = "SilentlyContinue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$DOTFILES = "C:\Users\shingo\AppData\Local\dotfiles"
$OLLAMA_URL = "http://localhost:11434/api/generate"
$OLLAMA_MODEL = "qwen2.5:latest"

function Get-OllamaCommitMsg {
    param([string]$diff)
    $truncated = if ($diff.Length -gt 3000) { $diff.Substring(0, 3000) + "`n...(truncated)" } else { $diff }
    $escaped = $truncated -replace '\\', '\\\\' -replace '"', '\"' -replace "`n", '\n' -replace "`r", ''
    $promptText = "Write a concise git commit message for these changes. First line: imperative mood, under 72 characters. Output the message only, no explanation.`n`n$escaped"
    $body = [System.Text.Encoding]::UTF8.GetBytes("{`"model`":`"$OLLAMA_MODEL`",`"prompt`":`"$promptText`",`"stream`":false}")
    try {
        $req = [System.Net.HttpWebRequest]::Create($OLLAMA_URL)
        $req.Method = "POST"; $req.ContentType = "application/json; charset=utf-8"
        $req.Timeout = 30000; $req.ContentLength = $body.Length
        $s = $req.GetRequestStream(); $s.Write($body, 0, $body.Length); $s.Close()
        $res = $req.GetResponse()
        $reader = New-Object System.IO.StreamReader($res.GetResponseStream(), [System.Text.Encoding]::UTF8)
        $json = $reader.ReadToEnd() | ConvertFrom-Json; $reader.Close()
        if ($json.response) { return $json.response.Trim() }
    } catch {}
    return $null
}

function Invoke-AutoCommit {
    param([string]$repoPath)
    if (-not (Test-Path (Join-Path $repoPath ".git"))) { return $null }

    $statusLines = git -C $repoPath status --short 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $statusLines) { return $null }

    # Detect if CLAUDE.md reminder is needed before staging
    $changedFiles = git -C $repoPath diff --name-only HEAD 2>$null
    $hookOrSettingsChanged = $changedFiles -match "settings\.json|[Hh]ooks[\\/]"
    $claudeMdChanged = $changedFiles -match "CLAUDE\.md|Claude\.md"
    $needsReminder = $hookOrSettingsChanged -and -not $claudeMdChanged

    # Stage tracked files only (safe: no accidental new file commits)
    git -C $repoPath add -u 2>$null

    $diff = git -C $repoPath diff --cached 2>$null
    if (-not $diff) { return @{ reminder = $needsReminder } }

    $msg = Get-OllamaCommitMsg $diff
    if (-not $msg) { $msg = "Update files" }

    git -C $repoPath commit -m $msg 2>$null
    return @{ committed = $true; repo = $repoPath; message = $msg; reminder = $needsReminder }
}

$messages = @()
$claudeReminder = $false
$cwd = (Get-Location).Path

# Auto-commit current repo (if different from dotfiles)
if ($cwd -ne $DOTFILES) {
    $r = Invoke-AutoCommit $cwd
    if ($r.committed) { $messages += "Auto-committed [$cwd]: $($r.message)" }
    if ($r.reminder)  { $claudeReminder = $true }
}

# Auto-commit dotfiles repo
$r = Invoke-AutoCommit $DOTFILES
if ($r.committed) { $messages += "Auto-committed [dotfiles]: $($r.message)" }
if ($r.reminder)  { $claudeReminder = $true }

if ($claudeReminder) {
    $messages += "Reminder: settings.json or hooks/ were changed — was CLAUDE.md updated?"
}

if ($messages.Count -gt 0) {
    @{ systemMessage = ($messages -join "`n") } | ConvertTo-Json -Compress
}
