#!/usr/bin/env bash
# Sync local system configuration back to Scar repo

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
DOTFILES_DIR="$REPO_DIR/dotfiles"

echo "[+] Syncing ~/.config/starship.toml -> $DOTFILES_DIR/starship.toml"
if [ -f "$HOME/.config/starship.toml" ]; then
    cp "$HOME/.config/starship.toml" "$DOTFILES_DIR/starship.toml"
    echo "[✓] starship.toml updated successfully."
else
    echo "[!] Warning: ~/.config/starship.toml not found!"
fi
