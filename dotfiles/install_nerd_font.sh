#!/usr/bin/env bash
# Helper script to download and install JetBrains Mono Nerd Font
# For Linux and macOS

set -e

FONT_NAME="JetBrainsMono"
FONT_VERSION="v3.3.0"
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/${FONT_NAME}.tar.xz"

echo "================================================="
echo " 🔤 Nerd Font Auto-Installer (${FONT_NAME})"
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

echo "[+] Downloading ${FONT_NAME} Nerd Font (${FONT_VERSION})..."
curl -fsSL "$DOWNLOAD_URL" -o "$TEMP_DIR/${FONT_NAME}.tar.xz"

echo "[+] Extracting fonts to $FONT_DIR..."
tar -xf "$TEMP_DIR/${FONT_NAME}.tar.xz" -C "$FONT_DIR"

if command -v fc-cache &> /dev/null; then
    echo "[+] Updating font cache (fc-cache)..."
    fc-cache -fv "$FONT_DIR" > /dev/null 2>&1
fi

echo "================================================="
echo " [✓] ${FONT_NAME} Nerd Font successfully installed!"
echo " 👉 Next step: Open your terminal settings and"
echo "    select '${FONT_NAME} Nerd Font' as your font."
echo "================================================="
