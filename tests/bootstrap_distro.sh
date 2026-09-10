#!/usr/bin/env bash
# Prepares a fresh Docker container of any supported distro with required shells and tools

set -e

echo "========================================="
echo " 📦 Bootstrapping Linux Container"
echo "========================================="

if command -v dnf &>/dev/null; then
    echo "[+] Detected DNF (Fedora/RHEL family)..."
    dnf install -y curl git tar xz which zsh fish util-linux procps-ng fontconfig
elif command -v apt-get &>/dev/null; then
    echo "[+] Detected APT (Ubuntu/Debian family)..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y curl git tar xz-utils zsh fish procps fontconfig ca-certificates
elif command -v pacman &>/dev/null; then
    echo "[+] Detected Pacman (Arch Linux family)..."
    pacman -Syu --noconfirm curl git tar xz zsh fish which procps-ng fontconfig ca-certificates
elif command -v zypper &>/dev/null; then
    echo "[+] Detected Zypper (openSUSE family)..."
    zypper refresh
    zypper install -y curl git tar xz which zsh fish procps fontconfig ca-certificates
elif command -v apk &>/dev/null; then
    echo "[+] Detected APK (Alpine Linux family)..."
    apk add --no-cache bash curl git tar xz zsh fish procps fontconfig shadow
else
    echo "[-] Error: Unrecognized package manager."
    exit 1
fi

echo "[✓] Container successfully bootstrapped with shells (Bash, Zsh, Fish) and base tools."
