#!/usr/bin/env bash
# my-starship - Starship Auto-Configurator for Linux/WSL/macOS
# Designed for autonomous AI Agents and users.

set -e

echo "================================================="
echo " 🚀 Starship Shell Configurator (Linux/WSL/macOS)"
echo "================================================="

# 1. Install Starship if not present
if ! command -v starship &> /dev/null; then
    echo "[+] Starship not found. Installing..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "[✓] Starship is already installed ($(starship --version | head -n 1))"
fi

# 2. Setup Config Directory & Download/Deploy starship.toml
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

STARSHIP_TOML="$CONFIG_DIR/starship.toml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

if [ -f "$SCRIPT_DIR/starship.toml" ]; then
    echo "[+] Copying starship.toml from local repository..."
    cp "$SCRIPT_DIR/starship.toml" "$STARSHIP_TOML"
else
    echo "[+] Fetching starship.toml from GitHub repository..."
    curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/starship.toml -o "$STARSHIP_TOML"
fi


echo "[✓] Configuration deployed to $STARSHIP_TOML"

# 3. Detect and configure installed shells

# Bash
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q 'starship init bash' "$HOME/.bashrc"; then
        echo "[+] Injecting Starship hook into ~/.bashrc"
        echo '' >> "$HOME/.bashrc"
        echo '# Starship prompt initialization' >> "$HOME/.bashrc"
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
    else
        echo "[✓] Bash profile already configured."
    fi
fi

# Zsh
if [ -f "$HOME/.zshrc" ] || command -v zsh &> /dev/null; then
    ZSH_RC="$HOME/.zshrc"
    touch "$ZSH_RC"
    if ! grep -q 'starship init zsh' "$ZSH_RC"; then
        echo "[+] Injecting Starship hook into ~/.zshrc"
        echo '' >> "$ZSH_RC"
        echo '# Starship prompt initialization' >> "$ZSH_RC"
        echo 'eval "$(starship init zsh)"' >> "$ZSH_RC"
    else
        echo "[✓] Zsh profile already configured."
    fi
fi

# Fish
FISH_CONFIG_DIR="$HOME/.config/fish"
if command -v fish &> /dev/null || [ -d "$FISH_CONFIG_DIR" ]; then
    mkdir -p "$FISH_CONFIG_DIR"
    FISH_CONFIG="$FISH_CONFIG_DIR/config.fish"
    touch "$FISH_CONFIG"
    if ! grep -q 'starship init fish' "$FISH_CONFIG"; then
        echo "[+] Injecting Starship hook into ~/.config/fish/config.fish"
        echo '' >> "$FISH_CONFIG"
        echo '# Starship prompt initialization' >> "$FISH_CONFIG"
        echo 'starship init fish | source' >> "$FISH_CONFIG"
    else
        echo "[✓] Fish profile already configured."
    fi
fi

# PowerShell (pwsh on Linux/macOS)
if command -v pwsh &> /dev/null; then
    PWSH_PROFILE_DIR="$HOME/.config/powershell"
    mkdir -p "$PWSH_PROFILE_DIR"
    PWSH_PROFILE="$PWSH_PROFILE_DIR/Microsoft.PowerShell_profile.ps1"
    touch "$PWSH_PROFILE"
    if ! grep -q 'starship init powershell' "$PWSH_PROFILE"; then
        echo "[+] Injecting Starship hook into $PWSH_PROFILE"
        echo '' >> "$PWSH_PROFILE"
        echo '# Starship prompt initialization' >> "$PWSH_PROFILE"
        echo 'Invoke-Expression (&starship init powershell)' >> "$PWSH_PROFILE"
    else
        echo "[✓] PowerShell profile already configured."
    fi
fi

# 4. Check for Nerd Font availability
echo ""
echo "[*] Verifying Nerd Font installation..."
HAS_NERD_FONT=false

if command -v fc-list &> /dev/null; then
    if fc-list : family | grep -qiE 'nerd|nf'; then
        HAS_NERD_FONT=true
    fi
elif [ "$(uname)" = "Darwin" ]; then
    if find ~/Library/Fonts /Library/Fonts -iname "*nerd*" 2>/dev/null | grep -q .; then
        HAS_NERD_FONT=true
    fi
fi

if [ "$HAS_NERD_FONT" = true ]; then
    echo "[✓] Nerd Font detected in system fonts!"
else
    echo "[!] Notice: No Nerd Font detected in your system fonts."
    echo "    To render prompt icons (, , , git symbols, etc.) correctly without broken glyphs,"
    echo "    please install a Nerd Font (recommended: JetBrains Mono Nerd Font or FiraCode NF):"
    echo "    👉 https://www.nerdfonts.com/font-downloads"
    echo "    And configure it as the font in your terminal emulator preferences."
fi

echo "================================================="
echo " ✨ Starship configuration successfully applied!"
echo "================================================="
