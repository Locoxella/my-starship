@echo off
REM Scar Dotfiles - Starship Auto-Configurator for Windows CMD (Command Prompt via Clink)

echo =================================================
echo  🚀 Starship Shell Configurator (Windows CMD)
echo =================================================

where starship >nul 2>nul
if %errorlevel% neq 0 (
    echo [+] Starship not found. Installing via winget...
    winget install --id Starship.Starship -e --accept-source-agreements --accept-package-agreements
) else (
    echo [✓] Starship is already installed.
)

if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"
echo [+] Fetching starship.toml configuration...
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/starship.toml' -OutFile '$env:USERPROFILE\.config\starship.toml'"

REM Configure Clink for CMD if installed
if not exist "%LOCALAPPDATA%\clink" mkdir "%LOCALAPPDATA%\clink"
echo [+] Setting up Starship Lua script for Clink...
echo load(io.popen('starship init cmd'):read("*a"))() > "%LOCALAPPDATA%\clink\starship.lua"

echo =================================================
echo  ✨ Windows CMD Starship setup complete!
echo =================================================
