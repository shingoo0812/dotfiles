# Checks git, RAG coverage, CLAUDE.md, and pending TODOs on session start.
$cwd = (Get-Location).Path
$ragConfig = "C:\Users\shingo\AppData\Local\dotfiles\rag\config.py"
$todosFile = "C:\Users\shingo\.claude\todos.md"

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

# CLAUDE.md check - collect relevant TODOs
$claudeMdPath = Join-Path $cwd "CLAUDE.md"
$claudeMdAlt  = Join-Path $cwd ".claude\CLAUDE.md"
$hasClaude = (Test-Path $claudeMdPath) -or (Test-Path $claudeMdAlt)
if (-not $hasClaude) {
    $issues += "- No CLAUDE.md found: TODO-001 applies (project CLAUDE.md template)"
}

# Pending TODOs (always show)
if (Test-Path $todosFile) {
    $todos = Get-Content $todosFile -Raw
    $pending = [regex]::Matches($todos, '(?m)^## \[TODO-\d+\].*\n\*\*Status:\*\* pending')
    if ($pending.Count -gt 0) {
        $titles = $pending | ForEach-Object { $_.Value -replace '\n.*','' -replace '## ','' }
        $issues += "- Pending TODOs: $($titles -join ' / ')"
    }
}

if ($issues.Count -gt 0) {
    $body = "PROJECT SETUP CHECK for '$cwd':`n" + ($issues -join "`n") + "`nAsk the user if they want to address the missing setup before proceeding."
    @{
        hookSpecificOutput = @{
            hookEventName   = "SessionStart"
            additionalContext = $body
        }
    } | ConvertTo-Json -Compress
}
