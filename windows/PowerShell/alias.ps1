# Utility Alias -------------------------------------------------------------
Set-Alias cat Get-Content
Set-Alias pwd Get-Location
Set-Alias find Select-String
# Set-Alias rm Remove-Item
Set-Alias mv Move-Item
# Set-Alias cp Copy-Item
Set-Alias c Clear-Host
Set-Alias .. GoUp


# function v {
#
#     # nvim --listen \\.\pipe\nvim $args # ClaudeのMCPを使用していいたときに利用していました
#     # パイプ名にプロセスIDを含めることで、複数のnvimを同時に起動できるようにする
#     $pipeName = "\\.\pipe\nvim-$PID"
#     nvim --listen $pipeName $args
# }
#

function l {
    dir -Force
}

function ll {
    dir -Force
}

function v {
    # nvim --listen \\.\pipe\nvim
    nvim --listen \\.\pipe\nvim $args
}
function wher { where.exe @args }
Set-Alias which wher

function jq{
    jq-windows-amd64.exe
}


function GoUp{
    cd ..
}

function cdv{
    cd 'C:\Users\shingo\AppData\Local\nvim'
}

function cdd{
    cd 'C:\Users\shingo\AppData\Local\dotfiles'
}

function cdc{
    cd 'C:\Users\shingo\Documents'
}
function cdl{
    cd 'F:\Downloads'
}
function cdcl{
    cd 'C:\Users\shingo\AppData\Roaming\Claude\'
}

function cdp { Set-Location 'C:\Users\shingo\OneDrive\Documents\PowerShell\' }
function desk { Set-Location 'C:\Users\shingo\Desktop' }
function app { Set-Location 'C:\Users\shingo\AppData' }
function cdf { Set-Location 'F:\' }
function env {Get-ChildItem Env:}
function wslsh {
    wsl --shutdown
}

function tail {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path,
        [int]$n = 10
    )
    Get-Content -Path $Path -Tail $n
}

function head {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path,
        [int]$n = 10
    )
    Get-Content -Path $Path -Head $n
}

function grep {
    param([string]$pattern)
    process {
        $_ | Where-Object { $_.Name -match $pattern }
    }
}

function f {
    # fzfで選択 + batでプレビュー
    $file = fzf --preview "bat --style=numbers --color=always {}"
    
    if ($file) {
        # nvimで開く
        nvim $file
    }
}

function touch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromRemainingArguments=$true)]
        [string[]]$Path
    )
    
    foreach ($p in $Path) {
        $pathItem = Get-Item -Path $p -ErrorAction SilentlyContinue
        if ($pathItem -eq $null) {
            Write-Verbose "Creating new file: $p"
            New-Item -Path $p -ItemType File | Out-Null
        } else {
            Write-Verbose "Updating timestamp for: $p"
            $time = Get-Date
            $pathItem.LastWriteTime = $time
            $pathItem.LastAccessTime = $time
        }
    }
}

function rm {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromRemainingArguments=$true, Position=0)]
        [string[]]$Path,
        
        [Alias('r')]
        [switch]$Recurse,
        
        [Alias('f')]
        [switch]$Force,
        
        [switch]$Verbose
    )
    
    begin {
        $items = @()
    }
    
    process {
        $items += $Path
    }
    
    end {
        foreach ($item in $items) {
            # -rf または -fr の組み合わせを検出
            if ($item -match '^-[rf]+$') {
                if ($item -match 'r') { $Recurse = $true }
                if ($item -match 'f') { $Force = $true }
                continue
            }
            
            $params = @{
                Path = $item
            }
            
            if ($Recurse) { $params['Recurse'] = $true }
            if ($Force) { $params['Force'] = $true }
            if ($Verbose) { $params['Verbose'] = $true }
            
            try {
                Remove-Item @params -ErrorAction Stop
            }
            catch {
                Write-Error "削除に失敗: $item - $_"
            }
        }
    }
}

function ln {
    param (
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )
    # Mimic 'ln -s source target'
    if ($Args[0] -eq "-s") {
        New-Item -ItemType SymbolicLink -Path $Args[2] -Target $Args[1]
    } else {
        # Fallback for hard links or standard New-Item usage
        Write-Host "Usage: ln -s <source> <target>" -ForegroundColor Yellow
    }
}

function cp_linux_style {
    <#
    .SYNOPSIS
        Linux-style copy function wrapper for PowerShell.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Source,

        [Parameter(Mandatory=$true, Position=1)]
        [string]$Destination,

        [Alias("r")]
        [switch]$Recursive
    )

    $params = @{
        Path = $Source
        Destination = $Destination
        Force = $true # Overwrite by default like Linux cp
    }

    if ($Recursive) {
        $params["Recurse"] = $true
    }

    # Use $PSBoundParameters to check if -Verbose was passed
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        $params["Verbose"] = $PSBoundParameters['Verbose']
    }

    Copy-Item @params
}

# Remove the default 'cp' alias first
if (Get-Alias cp -ErrorAction SilentlyContinue) {
    Remove-Item alias:cp
}

# Set new alias
Set-Alias -Name cp -Value cp_linux_style

# Docker -----------------------------------------
function dcu {
    param(
        [string[]]$args  # allow multiple args like --volumes --rmi all
    )
    docker compose up @args
}

function dcd {
    param(
        [string[]]$args
    )
    docker compose down @args
}


# Tools -----------------------------------------
function dlv {
    Push-Location "F:\Work\Programming\Python\Tools\DownloadYoutube"
    uv run python video-downloader.py
    Pop-Location
}

function imgcat { & wezterm imgcat $args }
