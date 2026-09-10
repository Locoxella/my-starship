#!/usr/bin/env bash
# Helper script to download and install Hack and FiraCode Nerd Fonts
# For Linux and macOS

set -e

FONT_VERSION="v3.3.0"
FONTS=("Hack" "FiraCode")

echo "================================================="
echo " 🔤 Nerd Font Auto-Installer (Hack & FiraCode)"
echo "================================================="

OS="$(uname)"
if [ "$OS" = "Linux" ]; then
    FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
elif [ "$OS" = "Darwin" ]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    echo "[-] Error: Unsupported operating system for this script: $OS"
    exit 1
fi

mkdir -p "$FONT_DIR"

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

for FONT_NAME in "${FONTS[@]}"; do
    echo "[+] Downloading ${FONT_NAME} Nerd Font (${FONT_VERSION})..."
    DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/${FONT_NAME}.tar.xz"
    curl -fsSL "$DOWNLOAD_URL" -o "$TEMP_DIR/${FONT_NAME}.tar.xz"

    echo "[+] Extracting ${FONT_NAME} to $FONT_DIR..."
    tar -xf "$TEMP_DIR/${FONT_NAME}.tar.xz" -C "$FONT_DIR"
done

if command -v fc-cache &> /dev/null; then
    echo "[+] Updating font cache (fc-cache)..."
    fc-cache -fv "$FONT_DIR" > /dev/null 2>&1
fi

echo "================================================="
echo " [✓] Hack & FiraCode Nerd Fonts successfully installed!"
echo " 👉 Recommended terminal font: 'Hack Nerd Font'"
echo " 👉 Recommended VS Code/editor font: 'FiraCode Nerd Font'"
echo "================================================="
