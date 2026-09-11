#!/usr/bin/env bash
# my-starship - Starship & Essential Modern CLI Tools Auto-Configurator
# Designed for autonomous AI Agents and users across Linux, WSL, and macOS.

set -e

echo "================================================="
echo " 🚀 Starship & Modern CLI Configurator"
echo "================================================="

# 0. Ensure user binary path exists
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    export PATH="$LOCAL_BIN:$PATH"
fi

# 1. Install Starship if not present
if ! command -v starship &> /dev/null; then
    echo "[+] Starship not found. Installing..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "[✓] Starship is already installed ($(starship --version | head -n 1))"
fi

# 2. Setup Config Directory & Deploy starship.toml
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

# 3. Install Bundled Modern CLI Tools (zoxide, fzf, eza, bat) if missing
echo ""
echo "[*] Verifying bundled CLI tools..."

# zoxide (smart directory jump)
if ! command -v zoxide &> /dev/null; then
    echo "[+] Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash 2>/dev/null || true
    if ! command -v zoxide &> /dev/null; then
        TEMP_ZOXIDE="$(mktemp -d)"
        ARCH="$(uname -m)"
        OS="$(uname)"
        ZOXIDE_VER=$(curl -sI https://github.com/ajeetdsouza/zoxide/releases/latest 2>/dev/null | grep -i '^location:' | sed 's/.*tag\/v*//' | tr -d '\r\n')
        ZOXIDE_VER="${ZOXIDE_VER:-0.10.0}"
        ZOXIDE_PKG=""
        if [ "$OS" = "Linux" ]; then
            if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "aarch64" ]; then
                ZOXIDE_PKG="zoxide-${ZOXIDE_VER}-${ARCH}-unknown-linux-musl.tar.gz"
            fi
        elif [ "$OS" = "Darwin" ]; then
            if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "arm64" ]; then
                [ "$ARCH" = "arm64" ] && ARCH="aarch64"
                ZOXIDE_PKG="zoxide-${ZOXIDE_VER}-${ARCH}-apple-darwin.tar.gz"
            fi
        fi
        if [ -n "$ZOXIDE_PKG" ]; then
            curl -fsSL "https://github.com/ajeetdsouza/zoxide/releases/download/v${ZOXIDE_VER}/${ZOXIDE_PKG}" -o "$TEMP_ZOXIDE/zoxide.tar.gz" 2>/dev/null && \
            tar -xzf "$TEMP_ZOXIDE/zoxide.tar.gz" -C "$TEMP_ZOXIDE" 2>/dev/null && \
            cp "$TEMP_ZOXIDE/zoxide" "$LOCAL_BIN/zoxide" 2>/dev/null && \
            chmod +x "$LOCAL_BIN/zoxide" 2>/dev/null || true
        fi
        rm -rf "$TEMP_ZOXIDE"
    fi
else
    echo "[✓] zoxide is already installed."
fi

# fzf (fuzzy finder)
if ! command -v fzf &> /dev/null; then
    echo "[+] Installing fzf..."
    if [ ! -d "$HOME/.fzf" ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" >/dev/null 2>&1 && \
        "$HOME/.fzf/install" --bin >/dev/null 2>&1 || true
    elif [ ! -f "$HOME/.fzf/bin/fzf" ]; then
        "$HOME/.fzf/install" --bin >/dev/null 2>&1 || true
    fi
    if [ -f "$HOME/.fzf/bin/fzf" ]; then
        ln -sf "$HOME/.fzf/bin/fzf" "$LOCAL_BIN/fzf"
    fi
else
    echo "[✓] fzf is already installed."
fi

# eza (modern ls replacement)
if ! command -v eza &> /dev/null; then
    echo "[+] Installing eza..."
    TEMP_EZA="$(mktemp -d)"
    ARCH="$(uname -m)"
    if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "aarch64" ]; then
        if [ "$(uname)" = "Linux" ]; then
            curl -fsSL "https://github.com/eza-community/eza/releases/latest/download/eza_${ARCH}-unknown-linux-gnu.tar.gz" -o "$TEMP_EZA/eza.tar.gz" 2>/dev/null && \
            tar -xzf "$TEMP_EZA/eza.tar.gz" -C "$LOCAL_BIN" 2>/dev/null && \
            chmod +x "$LOCAL_BIN/eza" 2>/dev/null || true
        fi
    fi
    rm -rf "$TEMP_EZA"
else
    echo "[✓] eza is already installed."
fi

# bat (modern cat replacement)
if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
    echo "[+] Installing bat..."
    TEMP_BAT="$(mktemp -d)"
    ARCH="$(uname -m)"
    if [ "$ARCH" = "x86_64" ] && [ "$(uname)" = "Linux" ]; then
        curl -fsSL "https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz" -o "$TEMP_BAT/bat.tar.gz" 2>/dev/null && \
        tar -xzf "$TEMP_BAT/bat.tar.gz" -C "$TEMP_BAT" 2>/dev/null && \
        cp "$TEMP_BAT"/bat-*/bat "$LOCAL_BIN/bat" 2>/dev/null && \
        chmod +x "$LOCAL_BIN/bat" 2>/dev/null || true
    fi
    rm -rf "$TEMP_BAT"
else
    echo "[✓] bat is already installed."
fi

# 4. Safe & Idempotent Shell Profile Configurations
echo ""
echo "[*] Configuring shell profiles..."

# --- Bash ---
if [ -f "$HOME/.bashrc" ] || command -v bash &> /dev/null; then
    touch "$HOME/.bashrc"
    # Ensure ~/.local/bin is in PATH
    if ! grep -q 'HOME/.local/bin' "$HOME/.bashrc" && ! grep -q '.local/bin' "$HOME/.bashrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi

    # Starship
    if ! grep -q 'starship init bash' "$HOME/.bashrc"; then
        echo "[+] Injecting Starship hook into ~/.bashrc"
        echo '' >> "$HOME/.bashrc"
        echo '# Starship prompt initialization' >> "$HOME/.bashrc"
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
    else
        echo "[✓] Bash: Starship already configured."
    fi

    # zoxide
    if command -v zoxide &> /dev/null; then
        if ! grep -q 'zoxide init bash' "$HOME/.bashrc"; then
            echo "[+] Injecting zoxide hook into ~/.bashrc"
            echo '# zoxide (smart directory jump)' >> "$HOME/.bashrc"
            echo 'eval "$(zoxide init bash)"' >> "$HOME/.bashrc"
        else
            echo "[✓] Bash: zoxide already configured."
        fi
    fi

    # fzf
    if command -v fzf &> /dev/null; then
        if ! grep -q 'fzf --bash' "$HOME/.bashrc" && ! grep -q '.fzf.bash' "$HOME/.bashrc"; then
            echo "[+] Injecting fzf bindings into ~/.bashrc"
            echo '# fzf key-bindings and completion' >> "$HOME/.bashrc"
            echo 'eval "$(fzf --bash 2>/dev/null || true)"' >> "$HOME/.bashrc"
        else
            echo "[✓] Bash: fzf already configured."
        fi
    fi

    # eza
    if command -v eza &> /dev/null; then
        if ! grep -q 'alias ls=.*eza' "$HOME/.bashrc"; then
            echo "[+] Injecting eza aliases into ~/.bashrc"
            echo '# eza aliases (modern ls)' >> "$HOME/.bashrc"
            echo "alias ls='eza --icons'" >> "$HOME/.bashrc"
            echo "alias ll='eza -l -g --icons'" >> "$HOME/.bashrc"
            echo "alias la='eza -a --icons'" >> "$HOME/.bashrc"
        else
            echo "[✓] Bash: eza aliases already configured."
        fi
    fi

    # bat
    if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
        if ! grep -q 'alias cat=.*bat' "$HOME/.bashrc"; then
            echo "[+] Injecting bat aliases into ~/.bashrc"
            echo '# bat aliases (modern cat)' >> "$HOME/.bashrc"
            if command -v bat &> /dev/null; then
                echo "alias cat='bat -P --style plain'" >> "$HOME/.bashrc"
                echo "alias less='bat'" >> "$HOME/.bashrc"
            else
                echo "alias bat='batcat'" >> "$HOME/.bashrc"
                echo "alias cat='batcat -P --style plain'" >> "$HOME/.bashrc"
            fi
        else
            echo "[✓] Bash: bat aliases already configured."
        fi
    fi
fi

# --- Zsh ---
if [ -f "$HOME/.zshrc" ] || command -v zsh &> /dev/null; then
    ZSH_RC="$HOME/.zshrc"
    touch "$ZSH_RC"

    # Ensure ~/.local/bin is in PATH
    if ! grep -q 'HOME/.local/bin' "$ZSH_RC" && ! grep -q '.local/bin' "$ZSH_RC"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSH_RC"
    fi

    # Starship
    if ! grep -q 'starship init zsh' "$ZSH_RC"; then
        echo "[+] Injecting Starship hook into ~/.zshrc"
        echo '' >> "$ZSH_RC"
        echo '# Starship prompt initialization' >> "$ZSH_RC"
        echo 'eval "$(starship init zsh)"' >> "$ZSH_RC"
    else
        echo "[✓] Zsh: Starship already configured."
    fi

    # zoxide
    if command -v zoxide &> /dev/null; then
        if ! grep -q 'zoxide init zsh' "$ZSH_RC"; then
            echo "[+] Injecting zoxide hook into ~/.zshrc"
            echo '# zoxide (smart directory jump)' >> "$ZSH_RC"
            echo 'eval "$(zoxide init zsh)"' >> "$ZSH_RC"
        else
            echo "[✓] Zsh: zoxide already configured."
        fi
    fi

    # fzf
    if command -v fzf &> /dev/null; then
        if ! grep -q 'fzf --zsh' "$ZSH_RC" && ! grep -q '.fzf.zsh' "$ZSH_RC"; then
            echo "[+] Injecting fzf bindings into ~/.zshrc"
            echo '# fzf key-bindings and completion' >> "$ZSH_RC"
            echo 'eval "$(fzf --zsh 2>/dev/null || true)"' >> "$ZSH_RC"
        else
            echo "[✓] Zsh: fzf already configured."
        fi
    fi

    # eza
    if command -v eza &> /dev/null; then
        if ! grep -q 'alias ls=.*eza' "$ZSH_RC"; then
            echo "[+] Injecting eza aliases into ~/.zshrc"
            echo '# eza aliases (modern ls)' >> "$ZSH_RC"
            echo "alias ls='eza --icons'" >> "$ZSH_RC"
            echo "alias ll='eza -l -g --icons'" >> "$ZSH_RC"
            echo "alias la='eza -a --icons'" >> "$ZSH_RC"
        else
            echo "[✓] Zsh: eza aliases already configured."
        fi
    fi

    # bat
    if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
        if ! grep -q 'alias cat=.*bat' "$ZSH_RC"; then
            echo "[+] Injecting bat aliases into ~/.zshrc"
            echo '# bat aliases (modern cat)' >> "$ZSH_RC"
            if command -v bat &> /dev/null; then
                echo "alias cat='bat -P --style plain'" >> "$ZSH_RC"
                echo "alias less='bat'" >> "$ZSH_RC"
            else
                echo "alias bat='batcat'" >> "$ZSH_RC"
                echo "alias cat='batcat -P --style plain'" >> "$ZSH_RC"
            fi
        else
            echo "[✓] Zsh: bat aliases already configured."
        fi
    fi
fi

# --- Fish ---
FISH_CONFIG_DIR="$HOME/.config/fish"
if command -v fish &> /dev/null || [ -d "$FISH_CONFIG_DIR" ]; then
    mkdir -p "$FISH_CONFIG_DIR"
    FISH_CONFIG="$FISH_CONFIG_DIR/config.fish"
    touch "$FISH_CONFIG"

    # Ensure ~/.local/bin is in PATH
    if ! grep -q 'fish_add_path.*\.local/bin' "$FISH_CONFIG" && ! grep -q 'PATH.*\.local/bin' "$FISH_CONFIG"; then
        echo 'fish_add_path $HOME/.local/bin' >> "$FISH_CONFIG"
    fi

    # Starship
    if ! grep -q 'starship init fish' "$FISH_CONFIG"; then
        echo "[+] Injecting Starship hook into config.fish"
        echo '' >> "$FISH_CONFIG"
        echo '# Starship prompt initialization' >> "$FISH_CONFIG"
        echo 'starship init fish | source' >> "$FISH_CONFIG"
    else
        echo "[✓] Fish: Starship already configured."
    fi

    # zoxide (respect existing jethrokuan/z plugin)
    if command -v zoxide &> /dev/null; then
        if ! grep -q 'zoxide init fish' "$FISH_CONFIG" && ! grep -q 'jethrokuan/z' "$FISH_CONFIG_DIR/fish_plugins" 2>/dev/null; then
            echo "[+] Injecting zoxide hook into config.fish"
            echo '# zoxide (smart directory jump)' >> "$FISH_CONFIG"
            echo 'zoxide init fish | source' >> "$FISH_CONFIG"
        else
            echo "[✓] Fish: z / zoxide already configured."
        fi
    fi

    # fzf (respect existing patrickf1/fzf.fish plugin)
    if command -v fzf &> /dev/null; then
        if ! grep -q 'fzf --fish' "$FISH_CONFIG" && ! grep -q 'fzf.fish' "$FISH_CONFIG_DIR/fish_plugins" 2>/dev/null; then
            echo "[+] Injecting fzf hook into config.fish"
            echo '# fzf integration' >> "$FISH_CONFIG"
            echo 'fzf --fish | source' >> "$FISH_CONFIG"
        else
            echo "[✓] Fish: fzf already configured."
        fi
    fi

    # eza
    if command -v eza &> /dev/null; then
        if ! grep -q 'alias ls=.*eza' "$FISH_CONFIG"; then
            echo "[+] Injecting eza aliases into config.fish"
            echo '# eza aliases (modern ls)' >> "$FISH_CONFIG"
            echo 'alias ls="eza --icons"' >> "$FISH_CONFIG"
            echo 'alias ll="eza -l -g --icons"' >> "$FISH_CONFIG"
            echo 'alias la="eza -a --icons"' >> "$FISH_CONFIG"
        else
            echo "[✓] Fish: eza aliases already configured."
        fi
    fi

    # bat
    if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
        if ! grep -q 'alias cat=.*bat' "$FISH_CONFIG"; then
            echo "[+] Injecting bat aliases into config.fish"
            echo '# bat aliases (modern cat)' >> "$FISH_CONFIG"
            if command -v bat &> /dev/null; then
                echo 'alias cat="bat -P --style plain"' >> "$FISH_CONFIG"
                echo 'alias less="bat"' >> "$FISH_CONFIG"
            else
                echo 'alias cat="batcat -P --style plain"' >> "$FISH_CONFIG"
                echo 'alias bat="batcat"' >> "$FISH_CONFIG"
            fi
        else
            echo "[✓] Fish: bat aliases already configured."
        fi
    fi
fi

# --- PowerShell (pwsh on Linux/macOS) ---
if command -v pwsh &> /dev/null; then
    PWSH_PROFILE_DIR="$HOME/.config/powershell"
    mkdir -p "$PWSH_PROFILE_DIR"
    PWSH_PROFILE="$PWSH_PROFILE_DIR/Microsoft.PowerShell_profile.ps1"
    touch "$PWSH_PROFILE"

    # Ensure ~/.local/bin is in PATH
    if ! grep -q 'HOME/\.local/bin' "$PWSH_PROFILE" && ! grep -q '\.local/bin' "$PWSH_PROFILE"; then
        echo 'if ($env:PATH -notlike "*$HOME/.local/bin*") { $env:PATH = "$HOME/.local/bin:$env:PATH" }' >> "$PWSH_PROFILE"
    fi

    # Starship
    if ! grep -q 'starship init powershell' "$PWSH_PROFILE"; then
        echo "[+] Injecting Starship hook into $PWSH_PROFILE"
        echo '' >> "$PWSH_PROFILE"
        echo '# Starship prompt initialization' >> "$PWSH_PROFILE"
        echo 'Invoke-Expression (&starship init powershell)' >> "$PWSH_PROFILE"
    else
        echo "[✓] PowerShell: Starship already configured."
    fi

    # zoxide
    if command -v zoxide &> /dev/null; then
        if ! grep -q 'zoxide init powershell' "$PWSH_PROFILE"; then
            echo "[+] Injecting zoxide hook into $PWSH_PROFILE"
            echo '# zoxide initialization' >> "$PWSH_PROFILE"
            echo 'Invoke-Expression (& { (zoxide init powershell | Out-String) })' >> "$PWSH_PROFILE"
        else
            echo "[✓] PowerShell: zoxide already configured."
        fi
    fi

    # eza
    if command -v eza &> /dev/null; then
        if ! grep -q 'function ls .*eza' "$PWSH_PROFILE" && ! grep -q 'function ls { eza' "$PWSH_PROFILE"; then
            echo "[+] Injecting eza functions into $PWSH_PROFILE"
            echo '# eza aliases' >> "$PWSH_PROFILE"
            echo 'function ls { eza --icons $args }' >> "$PWSH_PROFILE"
            echo 'function ll { eza -l -g --icons $args }' >> "$PWSH_PROFILE"
            echo 'function la { eza -a --icons $args }' >> "$PWSH_PROFILE"
        else
            echo "[✓] PowerShell: eza functions already configured."
        fi
    fi

    # bat
    if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
        if ! grep -q 'function cat .*bat' "$PWSH_PROFILE" && ! grep -q 'function cat { bat' "$PWSH_PROFILE"; then
            echo "[+] Injecting bat functions into $PWSH_PROFILE"
            echo '# bat aliases' >> "$PWSH_PROFILE"
            if command -v bat &> /dev/null; then
                echo 'function cat { bat -P --style plain $args }' >> "$PWSH_PROFILE"
                echo 'function less { bat $args }' >> "$PWSH_PROFILE"
            else
                echo 'function cat { batcat -P --style plain $args }' >> "$PWSH_PROFILE"
                echo 'function less { batcat $args }' >> "$PWSH_PROFILE"
            fi
        else
            echo "[✓] PowerShell: bat functions already configured."
        fi
    fi
fi

# 5. Check for Nerd Font availability (Automatic Install)
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
    echo "[!] No Nerd Font detected. Automatically installing Hack & FiraCode Nerd Fonts..."
    if [ -f "$SCRIPT_DIR/install_nerd_font.sh" ]; then
        bash "$SCRIPT_DIR/install_nerd_font.sh"
    else
        curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/install_nerd_font.sh | bash
    fi
fi

echo "================================================="
echo " ✨ All tools & Starship successfully configured!"
echo "================================================="
