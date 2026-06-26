# Checks for uncommitted git changes when Claude stops.
$status = git status --short 2>$null
if ($LASTEXITCODE -eq 0 -and $status) {
    $lines = ($status | Select-Object -First 10) -join "`n"
    $msg = "Uncommitted changes exist:`n$lines`nPlease run: git add / git commit"
    @{ systemMessage = $msg } | ConvertTo-Json -Compress
}
