# Checks git and RAG coverage on session start.
# Outputs additionalContext if setup is missing, so Claude asks the user.
$cwd = (Get-Location).Path
$ragConfig = "C:\Users\shingo\AppData\Local\dotfiles\rag\config.py"

$issues = @()

# Git check
if (-not (Test-Path (Join-Path $cwd ".git"))) {
    $issues += "- .git not found: this directory is not git-managed"
}

# RAG check
if (Test-Path $ragConfig) {
    $content = Get-Content $ragConfig -Raw
    $fwd = $cwd.Replace('\', '/')
    if (-not ($content -match [regex]::Escape($cwd) -or $content -match [regex]::Escape($fwd))) {
        $issues += "- Not in RAG WATCH_DIRS: this directory is not indexed by RAG"
    }
}

if ($issues.Count -gt 0) {
    $body = "PROJECT SETUP CHECK for '$cwd':`n" + ($issues -join "`n") + "`nAsk the user if they want to initialize the missing setup before proceeding."
    @{
        hookSpecificOutput = @{
            hookEventName   = "SessionStart"
            additionalContext = $body
        }
    } | ConvertTo-Json -Compress
}
