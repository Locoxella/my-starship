<#
.SYNOPSIS
    my-starship - Starship & Modern CLI Tools Auto-Configurator for Windows (PowerShell / WSL)
    Designed for autonomous AI Agents and Windows users.
#>

$ErrorActionPreference = "Stop"

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " 🚀 Starship & Modern CLI Configurator (Windows)" -ForegroundColor Cyan
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

# 3. Check & Install Bundled Modern CLI Tools (zoxide, fzf, eza, bat)
Write-Host ""
Write-Host "[*] Verifying bundled CLI tools (zoxide, fzf, eza, bat)..." -ForegroundColor Cyan

$cliTools = @(
    @{ Name = "zoxide"; Id = "ajeetdsouza.zoxide" },
    @{ Name = "fzf";    Id = "junegunn.fzf" },
    @{ Name = "eza";    Id = "eza-community.eza" },
    @{ Name = "bat";    Id = "sharkdp.bat" }
)

foreach ($tool in $cliTools) {
    if (-not (Get-Command $tool.Name -ErrorAction SilentlyContinue)) {
        Write-Host "[+] Installing $($tool.Name) via winget..." -ForegroundColor Yellow
        try {
            winget install -e --id $tool.Id --accept-source-agreements --accept-package-agreements
        } catch {
            Write-Host "[!] Notice: Could not install $($tool.Name) via winget automatically: $_" -ForegroundColor Gray
        }
    } else {
        Write-Host "[✓] $($tool.Name) is already installed." -ForegroundColor Green
    }
}

# 4. Configure PowerShell Profiles (Safe & Idempotent)
Write-Host ""
Write-Host "[*] Configuring PowerShell profiles..." -ForegroundColor Cyan

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
        
        # Starship
        if ($content -notlike "*starship init powershell*") {
            Write-Host "[+] Injecting Starship hook into: $prof" -ForegroundColor Yellow
            Add-Content -Path $prof -Value "`n# Starship prompt initialization`nInvoke-Expression (&starship init powershell)"
        } else {
            Write-Host "[✓] Profile already has Starship: $prof" -ForegroundColor Green
        }

        # zoxide
        if ($content -notlike "*zoxide init powershell*" -and (Get-Command zoxide -ErrorAction SilentlyContinue)) {
            Write-Host "[+] Injecting zoxide hook into: $prof" -ForegroundColor Yellow
            Add-Content -Path $prof -Value "`n# zoxide initialization`nInvoke-Expression (& { (zoxide init powershell | Out-String) })"
        }

        # eza aliases
        if ($content -notlike "*function ls*eza*" -and (Get-Command eza -ErrorAction SilentlyContinue)) {
            Write-Host "[+] Injecting eza aliases into: $prof" -ForegroundColor Yellow
            Add-Content -Path $prof -Value "`n# eza aliases`nfunction ls { eza --icons `$args }`nfunction ll { eza -l -g --icons `$args }`nfunction la { eza -a --icons `$args }"
        }

        # bat aliases
        if ($content -notlike "*function cat*bat*" -and (Get-Command bat -ErrorAction SilentlyContinue)) {
            Write-Host "[+] Injecting bat aliases into: $prof" -ForegroundColor Yellow
            Add-Content -Path $prof -Value "`n# bat aliases`nfunction cat { bat -P --style plain `$args }`nfunction less { bat `$args }"
        }
    }
}

# 5. Check for WSL (Windows Subsystem for Linux)
$wslCmd = Get-Command wsl -ErrorAction SilentlyContinue
if ($wslCmd) {
    Write-Host "[+] WSL detected! Offering automated WSL setup..." -ForegroundColor Cyan
    try {
        wsl bash -c "curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/setup_starship.sh | bash"
        Write-Host "[✓] WSL instances successfully updated with Starship & tools!" -ForegroundColor Green
    } catch {
        Write-Host "[!] Could not configure WSL automatically: $_" -ForegroundColor Yellow
    }
}

# 6. Check for Nerd Font availability (Automatic Install)
Write-Host ""
Write-Host "[*] Verifying Nerd Font installation in Windows..." -ForegroundColor Cyan
try {
    $installedFonts = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue).PSObject.Properties.Value
    $userFonts = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue).PSObject.Properties.Value
    $hasNerdFont = ($installedFonts -match "Nerd|NF") -or ($userFonts -match "Nerd|NF")
} catch {
    $hasNerdFont = $false
}

if ($hasNerdFont) {
    Write-Host "[✓] Nerd Font detected in Windows!" -ForegroundColor Green
} else {
    Write-Host "[!] No Nerd Font detected. Installing Hack & FiraCode Nerd Fonts via winget..." -ForegroundColor Yellow
    try {
        winget install -e --id NerdFonts.Hack --accept-source-agreements --accept-package-agreements
        winget install -e --id NerdFonts.FiraCode --accept-source-agreements --accept-package-agreements
        Write-Host "[✓] Hack & FiraCode Nerd Fonts installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "[!] Could not install fonts via winget automatically: $_" -ForegroundColor Yellow
        Write-Host "    Download manually from: https://www.nerdfonts.com/font-downloads" -ForegroundColor Gray
    }
}

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ✨ All tools & Starship successfully configured!" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
