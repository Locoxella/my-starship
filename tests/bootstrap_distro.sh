#!/usr/bin/env bash
# Prepares a fresh Docker container of any supported distro with required shells and tools

set -e

echo "========================================="
echo " 📦 Bootstrapping Linux Container"
echo "========================================="

if command -v dnf &>/dev/null; then
    echo "[+] Detected DNF (Fedora/RHEL family)..."
    dnf install -y curl git tar gzip xz which zsh fish util-linux procps-ng fontconfig fastfetch
elif command -v apt-get &>/dev/null; then
    echo "[+] Detected APT (Ubuntu/Debian family)..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y curl git tar gzip xz-utils zsh fish procps fontconfig ca-certificates fastfetch || \
    apt-get install -y curl git tar gzip xz-utils zsh fish procps fontconfig ca-certificates
elif command -v pacman &>/dev/null; then
    echo "[+] Detected Pacman (Arch Linux family)..."
    pacman -Syu --noconfirm curl git tar gzip xz zsh fish which procps-ng fontconfig ca-certificates fastfetch
elif command -v zypper &>/dev/null; then
    echo "[+] Detected Zypper (openSUSE family)..."
    zypper refresh
    zypper install -y curl git tar gzip xz which zsh fish procps fontconfig ca-certificates fastfetch
elif command -v apk &>/dev/null; then
    echo "[+] Detected APK (Alpine Linux family)..."
    apk add --no-cache bash curl git tar gzip xz zsh fish procps fontconfig shadow fastfetch
else
    echo "[-] Error: Unrecognized package manager."
    exit 1
fi

# Install PowerShell Core (pwsh)
if ! command -v pwsh &>/dev/null; then
    echo "[+] Installing PowerShell (pwsh)..."
    PWSH_DIR="/opt/microsoft/powershell/7"
    mkdir -p "$PWSH_DIR"
    ARCH="$(uname -m)"
    PKG_ARCH="x64"
    [ "$ARCH" = "aarch64" ] && PKG_ARCH="arm64"
    curl -fsSL "https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-linux-${PKG_ARCH}.tar.gz" | tar -xz -C "$PWSH_DIR"
    chmod +x "$PWSH_DIR/pwsh"
    cat << 'WRAPPER_EOF' > /usr/local/bin/pwsh
#!/bin/sh
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
exec /opt/microsoft/powershell/7/pwsh "$@"
WRAPPER_EOF
    chmod +x /usr/local/bin/pwsh
    echo "[✓] PowerShell installed: $(pwsh --version)"
fi

echo "[✓] Container successfully bootstrapped with shells (Bash, Zsh, Fish, PowerShell) and base tools."
