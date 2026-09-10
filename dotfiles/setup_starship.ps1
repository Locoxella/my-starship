<#
.SYNOPSIS
    my-starship - Starship Auto-Configurator for Windows (PowerShell / WSL)
    Designed for autonomous AI Agents and Windows users.
#>

$ErrorActionPreference = "Stop"

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " 🚀 Starship Shell Configurator (Windows/PowerShell)" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# 1. Check if Starship is installed
$starshipCmd = Get-Command starship -ErrorAction SilentlyContinue

if (-not $starshipCmd) {
    Write-Host "[+] Starship not found. Installing via winget..." -ForegroundColor Yellow
    try {
        winget install --id Starship.Starship -e --accept-source-agreements --accept-package-agreements
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } catch {
        Write-Host "[!] Winget install failed. Trying scoop/manual fallback..." -ForegroundColor Red
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://starship.rs/install.ps1')
    }
} else {
    Write-Host "[✓] Starship is already installed." -ForegroundColor Green
}

# 2. Setup Config Directory & Deploy starship.toml
$configDir = Join-Path $HOME ".config"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir | Out-Null
}

$targetToml = Join-Path $configDir "starship.toml"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

if (Test-Path (Join-Path $scriptDir "starship.toml")) {
    Write-Host "[+] Copying starship.toml from local folder..." -ForegroundColor Green
    Copy-Item -Path (Join-Path $scriptDir "starship.toml") -Destination $targetToml -Force
} else {
    Write-Host "[+] Fetching starship.toml from GitHub..." -ForegroundColor Green
    $url = "https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/starship.toml"
    Invoke-WebRequest -Uri $url -OutFile $targetToml
}

Write-Host "[✓] Configuration deployed to $targetToml" -ForegroundColor Green

# 3. Configure PowerShell Profiles (Supports both Windows PowerShell 5.1 & PowerShell Core 7+)
$profilesToUpdate = @(
    $PROFILE,
    "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
) | Select-Object -Unique

foreach ($prof in $profilesToUpdate) {
    if ($prof) {
        $parentDir = Split-Path -Parent $prof
        if (-not (Test-Path $parentDir)) { New-Item -ItemType Directory -Path $parentDir -Force | Out-Null }
        if (-not (Test-Path $prof)) { New-Item -ItemType File -Path $prof -Force | Out-Null }
        
        $content = Get-Content $prof -Raw -ErrorAction SilentlyContinue
        if ($content -notlike "*starship init powershell*") {
            Write-Host "[+] Injecting Starship hook into profile: $prof" -ForegroundColor Yellow
            Add-Content -Path $prof -Value "`n# Starship prompt initialization`nInvoke-Expression (&starship init powershell)"
        } else {
            Write-Host "[✓] Profile already configured: $prof" -ForegroundColor Green
        }
    }
}


# 4. Check for WSL (Windows Subsystem for Linux)
$wslCmd = Get-Command wsl -ErrorAction SilentlyContinue
if ($wslCmd) {
    Write-Host "[+] WSL detected! Offering automated WSL setup..." -ForegroundColor Cyan
    try {
        wsl bash -c "curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/setup_starship.sh | bash"
        Write-Host "[✓] WSL instances successfully updated with Starship!" -ForegroundColor Green
    } catch {
        Write-Host "[!] Could not configure WSL automatically: $_" -ForegroundColor Yellow
    }
}

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ✨ Starship configuration successfully applied!" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
