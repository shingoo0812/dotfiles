# PostToolUse hook: append newly installed packages to their list files.
#
# Project-local (only if file exists in $PWD):
#   pip / python -m pip  -> requirements.txt
#   conda install        -> conda-packages.txt
#   scoop install        -> scoop.txt
#
# Dotfiles (always updated):
#   scoop install  -> dotfiles/windows/install/scoop.txt
#   winget install -> dotfiles/windows/install/winget.txt
#   choco install  -> dotfiles/windows/install/choco.txt
#   apt install    -> dotfiles/linux/install/apt.txt
#   brew install   -> dotfiles/linux/install/brew.txt

$DOTFILES = "C:\Users\shingo\AppData\Local\dotfiles"

$raw = [Console]::In.ReadToEnd().Trim()
if (-not $raw) { exit 0 }
try { $data = $raw | ConvertFrom-Json } catch { exit 0 }

if ($data.tool_name -notin @('Bash', 'PowerShell')) { exit 0 }
if ($data.tool_response.is_error) { exit 0 }

$cmd = $data.tool_input.command
if (-not $cmd) { exit 0 }

function Add-To {
    param([string]$File, [string[]]$Pkgs, [switch]$Always)
    if (-not $Always -and -not (Test-Path $File)) { return }
    $existing = if (Test-Path $File) { Get-Content $File } else { @() }
    $added = @()
    foreach ($p in $Pkgs) {
        $p = $p.Trim()
        if ($p -and ($existing -notcontains $p)) {
            Add-Content $File $p
            $added += $p
        }
    }
    if ($added) { Write-Host "[hook] $(Split-Path $File -Leaf) += $($added -join ', ')" }
}

function Strip-Flags {
    param([string]$s)
    # remove flags and their arguments, return bare package names
    $tokens = $s.Trim() -split '\s+'
    $result = @(); $skipNext = $false
    foreach ($t in $tokens) {
        if ($skipNext) { $skipNext = $false; continue }
        if ($t -match '^--\S+=') { continue }         # --flag=value
        if ($t -match '^-[a-zA-Z]$|^--\S+$') {       # -f or --flag (value follows)
            # single-letter flags that take a value
            if ($t -in @('-c','-n','-p','--name','--prefix','--channel','--revision')) { $skipNext = $true }
            continue
        }
        $result += $t
    }
    $result
}

# --- scoop ---
if ($cmd -match '(?:^|[;&|]\s*)scoop install\s+([^\n;&|]+)') {
    $pkgs = Strip-Flags $Matches[1]
    Add-To (Join-Path $PWD 'scoop.txt') $pkgs
    Add-To "$DOTFILES\windows\install\scoop.txt" $pkgs -Always
}

# --- winget ---
if ($cmd -match '(?:^|[;&|]\s*)winget install\s+([^\n;&|]+)') {
    $pkgs = Strip-Flags $Matches[1]
    Add-To "$DOTFILES\windows\install\winget.txt" $pkgs -Always
}

# --- choco ---
if ($cmd -match '(?:^|[;&|]\s*)choco(?:latey)? install\s+([^\n;&|]+)') {
    $pkgs = Strip-Flags $Matches[1]
    Add-To "$DOTFILES\windows\install\choco.txt" $pkgs -Always
}

# --- pip ---
if ($cmd -match '(?:pip3?|pip\.exe)\s+install\s+([^\n;&|]+)' -or
    $cmd -match '(?:python\S*)\s+-m\s+pip\s+install\s+([^\n;&|]+)') {
    $pkgs = Strip-Flags $Matches[1]
    Add-To (Join-Path $PWD 'requirements.txt') $pkgs
}

# --- conda ---
if ($cmd -match '(?:^|[;&|]\s*)conda install\s+([^\n;&|]+)') {
    $pkgs = Strip-Flags $Matches[1]
    Add-To (Join-Path $PWD 'conda-packages.txt') $pkgs
}

# --- apt ---
if ($cmd -match '(?:^|[;&|]\s*)apt(?:-get)? install\s+([^\n;&|]+)') {
    $pkgs = Strip-Flags $Matches[1]
    Add-To "$DOTFILES\linux\install\apt.txt" $pkgs -Always
}

# --- brew ---
if ($cmd -match '(?:^|[;&|]\s*)brew install\s+([^\n;&|]+)') {
    $pkgs = Strip-Flags $Matches[1]
    Add-To "$DOTFILES\linux\install\brew.txt" $pkgs -Always
}
