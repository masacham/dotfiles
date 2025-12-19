# Windows PowerShell symlink management script
# Requires: PowerShell 5.0+ and Administrator privileges
# Usage: .\scripts\symlink.ps1 [-Action Create|Remove|Verify]

param(
    [ValidateSet('Create', 'Remove', 'Verify')]
    [string]$Action = 'Create'
)

# Get dotfiles directory
$DotfilesDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$BackupDir = Join-Path $HOME ".dotfiles-backup"

# Colors
$Green = "Green"
$Red = "Red"
$Yellow = "Yellow"
$Cyan = "Cyan"

function Write-Status {
    param([string]$Symbol, [string]$Message, [string]$Color = "White")
    Write-Host "[$Symbol] $Message" -ForegroundColor $Color
}

function Ensure-AdminPrivileges {
    $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Status "X" "This script requires Administrator privileges!" $Red
        Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
        exit 1
    }
}

function Create-BackupDir {
    if (-not (Test-Path $BackupDir)) {
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        Write-Status "OK" "Backup directory created: $BackupDir" $Green
    }
}

function Backup-Item {
    param([string]$Path)
    if (Test-Path $Path) {
        $BackupPath = Join-Path $BackupDir (Split-Path -Leaf $Path)
        Copy-Item -Path $Path -Destination $BackupPath -Recurse -Force
        Write-Status ">>" "Backed up: $Path" $Yellow
    }
}

function Create-Symlink {
    param(
        [string]$Source,
        [string]$Target
    )
    
    $Source = $Source -replace "/", "\"
    $Target = $Target -replace "/", "\"
    
    if (-not (Test-Path $Source)) {
        Write-Status "X" "Source not found: $Source" $Red
        return $false
    }
    
    # Create parent directory if needed
    $TargetParent = Split-Path -Parent $Target
    if (-not (Test-Path $TargetParent)) {
        New-Item -ItemType Directory -Path $TargetParent -Force | Out-Null
    }
    
    # Remove existing item
    if (Test-Path $Target) {
        if ((Get-Item $Target).LinkType -eq "SymbolicLink") {
            Remove-Item -Path $Target -Force
        }
        else {
            Backup-Item $Target
            Remove-Item -Path $Target -Recurse -Force
        }
    }
    

    # Create symlink
    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
        Write-Status "OK" "Symlink created: $Target -> $Source" $Green
        return $true
    }
    catch {
        Write-Status "X" "Failed to create symlink: $_" $Red
        return $false
    }
} 


function Remove-Symlink {
    param([string]$Path)
    
    $Path = $Path -replace "/", "\"
    
    if (Test-Path $Path) {
        if ((Get-Item $Path).LinkType -eq "SymbolicLink") {
            Remove-Item -Path $Path -Force
            Write-Status "OK" "Symlink removed: $Path" $Green
        }
    }
}

function Verify-Symlink {
    param([string]$Path)
    
    $Path = $Path -replace "/", "\"
    
    if (Test-Path $Path) {
        $Item = Get-Item $Path
        if ($Item.LinkType -eq "SymbolicLink") {
            $Target = (Get-Item $Path).Target
            Write-Status "OK" "$Path -> $Target" $Green
            return $true
        }
        else {
            Write-Status ">>" "$Path (regular file/directory)" $Yellow
            return $true
        }
    }
    else {
        Write-Status "X" "$Path (not found)" $Red
        return $false
    }
}

function Create-Symlinks {
    Write-Host "`nCreating symlinks for Windows...`n" -ForegroundColor $Yellow
    Create-BackupDir
    
    $LocalAppData = $env:LOCALAPPDATA
    $ConfigDir = Join-Path $env:USERPROFILE ".config"
    
    # Editor config - Neovim uses LOCALAPPDATA
    Create-Symlink "$DotfilesDir\config\editor\nvim" "$LocalAppData\nvim"
    
    # Terminal config - Wezterm uses ~/.config
    Create-Symlink "$DotfilesDir\config\other\wezterm" "$ConfigDir\wezterm"
    
    Write-Host "`nDone!`n" -ForegroundColor $Green
}

function Remove-Symlinks {
    Write-Host "`nRemoving symlinks...`n" -ForegroundColor $Yellow
    
    $LocalAppData = $env:LOCALAPPDATA
    $ConfigDir = Join-Path $env:USERPROFILE ".config"
    
    Remove-Symlink "$LocalAppData\nvim"
    Remove-Symlink "$ConfigDir\wezterm"
    
    Write-Host "`nDone!`n" -ForegroundColor $Green
}

function Verify-Symlinks {
    Write-Host "`nVerifying symlinks...`n" -ForegroundColor $Yellow
    
    $LocalAppData = $env:LOCALAPPDATA
    $ConfigDir = Join-Path $env:USERPROFILE ".config"
    
    Verify-Symlink "$LocalAppData\nvim"
    Verify-Symlink "$ConfigDir\wezterm"
    
    Write-Host ""
}

# Main execution
Ensure-AdminPrivileges

switch ($Action) {
    'Create' {
        Create-Symlinks
    }
    'Remove' {
        Remove-Symlinks
    }
    'Verify' {
        Verify-Symlinks
    }
}
