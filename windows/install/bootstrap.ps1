<#
.SYNOPSIS
    Windows dotfiles symlink installer.
    Reads every links.prop under windows/ and creates symlinks.

.DESCRIPTION
    links.prop format (one entry per line):
        $DOTFILES\source\file=$HOME\target\file
    Supported variables: $DOTFILES, $HOME, $APPDATA
    Lines beginning with # are ignored.

.NOTES
    Requires either Administrator privileges or Windows Developer Mode.
#>

param(
    [switch]$Force  # overwrite all existing symlinks without prompting
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- Paths ---
$DOTFILES = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$HOME_DIR  = $env:USERPROFILE
$APPDATA_DIR = $env:APPDATA

# --- Privilege check ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
$devMode = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' `
    -Name 'AllowDevelopmentWithoutDevLicense' -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense -eq 1

if (-not $isAdmin -and -not $devMode) {
    Write-Warning 'Neither Administrator nor Developer Mode detected. Symlink creation may fail.'
    Write-Warning 'Run as Administrator or enable Settings > Developer Mode.'
}

# --- Helpers ---
function Write-Info    { param([string]$m); Write-Host "  [ .. ] $m" -ForegroundColor Cyan }
function Write-Ok      { param([string]$m); Write-Host "  [ OK ] $m" -ForegroundColor Green }
function Write-Fail    { param([string]$m); Write-Host "  [FAIL] $m" -ForegroundColor Red }

function Expand-Vars {
    param([string]$path)
    $path -replace [regex]::Escape('$DOTFILES'), $DOTFILES `
          -replace [regex]::Escape('$APPDATA'),  $APPDATA_DIR `
          -replace [regex]::Escape('$HOME'),      $HOME_DIR
}

function New-Symlink {
    param([string]$src, [string]$dst)

    if (-not (Test-Path $src)) {
        Write-Fail "source not found: $src"
        return
    }

    if (Test-Path $dst -PathType Any) {
        $item = Get-Item $dst -Force
        $isLink = [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)

        if ($isLink -and $item.Target -eq $src) {
            Write-Ok "already linked: $dst"
            return
        }

        if ($Force) {
            $action = 'O'
        } else {
            Write-Host "  Exists: $dst" -ForegroundColor Yellow
            if ($isLink) { Write-Host "          (currently -> $($item.Target))" -ForegroundColor DarkGray }
            $action = (Read-Host '  [O]verwrite, [B]ackup, [S]kip?').ToUpper()
        }

        switch ($action) {
            'O' {
                Remove-Item $dst -Force -Recurse
                Write-Info "removed: $dst"
            }
            'B' {
                $backup = "$dst.backup"
                Rename-Item $dst $backup
                Write-Ok "backed up -> $backup"
            }
            'S' {
                Write-Ok "skipped: $dst"
                return
            }
            default {
                Write-Fail "unknown action '$action', skipping: $dst"
                return
            }
        }
    }

    $dir = Split-Path $dst -Parent
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    try {
        New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
        Write-Ok "linked: $src`n         -> $dst"
    } catch {
        Write-Fail "failed to link $dst : $_"
    }
}

# --- Main ---
Write-Host ""
Write-Info "Installing Windows dotfiles"
Write-Host "  DOTFILES = $DOTFILES"
Write-Host ""

$linkFiles = Get-ChildItem -Path (Join-Path $DOTFILES 'windows') -Filter 'links.prop' -Recurse -File

if (-not $linkFiles) {
    Write-Warning 'No links.prop files found under windows/.'
    exit 0
}

foreach ($linkFile in $linkFiles) {
    Write-Info "Processing: $($linkFile.FullName)"
    $lines = Get-Content $linkFile.FullName

    foreach ($line in $lines) {
        $line = $line.Trim()
        if ([string]::IsNullOrEmpty($line) -or $line.StartsWith('#')) { continue }

        $parts = $line -split '=', 2
        if ($parts.Count -ne 2) {
            Write-Fail "bad entry (expected src=dst): $line"
            continue
        }

        $src = Expand-Vars $parts[0].Trim()
        $dst = Expand-Vars $parts[1].Trim()
        New-Symlink -src $src -dst $dst
    }

    Write-Host ""
}

Write-Ok 'All done!'
