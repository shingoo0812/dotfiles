<#
.SYNOPSIS
    Windows package installer — reads scoop.txt / winget.txt / choco.txt
    and installs any missing packages.

.PARAMETER DryRun
    Print what would be installed without actually installing anything.
#>

param([switch]$DryRun)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

$INSTALL_DIR = $PSScriptRoot

function Write-Info    { param([string]$m); Write-Host "  [ .. ] $m" -ForegroundColor Cyan }
function Write-Ok      { param([string]$m); Write-Host "  [ OK ] $m" -ForegroundColor Green }
function Write-Skip    { param([string]$m); Write-Host "  [SKIP] $m" -ForegroundColor DarkGray }
function Write-Fail    { param([string]$m); Write-Host "  [FAIL] $m" -ForegroundColor Red }

function Read-PackageFile {
    param([string]$path)
    if (-not (Test-Path $path)) { return @() }
    Get-Content $path |
        ForEach-Object { ($_ -split '#')[0].Trim() } |
        Where-Object { $_ -ne '' }
}

# --- Scoop ---
function Install-ScoopPackages {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Info "Scoop not found, skipping scoop.txt"
        return
    }

    $pkgFile = Join-Path $INSTALL_DIR 'scoop.txt'
    $packages = Read-PackageFile $pkgFile
    if (-not $packages) { return }

    $scoopInstalled = (scoop list 2>&1) -join "`n"

    Write-Host "`n[Scoop]" -ForegroundColor Yellow
    foreach ($pkg in $packages) {
        if ($scoopInstalled -match "(?m)^\s*$([regex]::Escape($pkg))\s") {
            Write-Skip "scoop: $pkg"
        } elseif ($DryRun) {
            Write-Info "scoop: would install $pkg"
        } else {
            Write-Info "scoop: installing $pkg ..."
            scoop install $pkg
            if ($LASTEXITCODE -eq 0) { Write-Ok "scoop: $pkg" } else { Write-Fail "scoop: $pkg" }
        }
    }
}

# --- WinGet ---
function Install-WinGetPackages {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Info "winget not found, skipping winget.txt"
        return
    }

    $pkgFile = Join-Path $INSTALL_DIR 'winget.txt'
    $packages = Read-PackageFile $pkgFile
    if (-not $packages) { return }

    Write-Info "Fetching installed WinGet packages..."
    $wingetInstalled = (winget list 2>&1) -join "`n"

    Write-Host "`n[WinGet]" -ForegroundColor Yellow
    foreach ($id in $packages) {
        if ($wingetInstalled -match [regex]::Escape($id)) {
            Write-Skip "winget: $id"
        } elseif ($DryRun) {
            Write-Info "winget: would install $id"
        } else {
            Write-Info "winget: installing $id ..."
            winget install --id $id --exact --accept-package-agreements --accept-source-agreements
            if ($LASTEXITCODE -eq 0) { Write-Ok "winget: $id" } else { Write-Fail "winget: $id" }
        }
    }
}

# --- Chocolatey ---
function Install-ChocoPackages {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Info "choco not found, skipping choco.txt"
        return
    }

    $pkgFile = Join-Path $INSTALL_DIR 'choco.txt'
    $packages = Read-PackageFile $pkgFile
    if (-not $packages) { return }

    $chocoInstalled = (choco list 2>&1) -join "`n"

    Write-Host "`n[Chocolatey]" -ForegroundColor Yellow
    foreach ($pkg in $packages) {
        if ($chocoInstalled -match "(?m)^$([regex]::Escape($pkg))\s") {
            Write-Skip "choco: $pkg"
        } elseif ($DryRun) {
            Write-Info "choco: would install $pkg"
        } else {
            Write-Info "choco: installing $pkg ..."
            choco install $pkg -y
            if ($LASTEXITCODE -eq 0) { Write-Ok "choco: $pkg" } else { Write-Fail "choco: $pkg" }
        }
    }
}

# --- Main ---
if ($DryRun) { Write-Host "`n[DRY RUN — nothing will be installed]`n" -ForegroundColor Magenta }

Install-ScoopPackages
Install-WinGetPackages
Install-ChocoPackages

Write-Host ""
Write-Ok "Done!"
