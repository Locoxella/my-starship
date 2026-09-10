#!/usr/bin/env bash
# Test suite for my-starship installation
# Verifies binaries, configs, fonts, shell profile hooks, and idempotency

set -e

echo "========================================="
echo " 🧪 Running Installation Test Suite"
echo "========================================="

export PATH="$HOME/.local/bin:$PATH"

# 1. Check Binaries
echo "[TEST 1/5] Checking required binaries..."
command -v starship >/dev/null || (echo "[-] FAIL: starship binary not found in PATH" && exit 1)
echo "  ✓ starship: $(starship --version | head -n 1)"

command -v zoxide >/dev/null || (echo "[-] FAIL: zoxide binary not found in PATH" && exit 1)
echo "  ✓ zoxide: $(zoxide --version)"

command -v fzf >/dev/null || (echo "[-] FAIL: fzf binary not found in PATH" && exit 1)
echo "  ✓ fzf: $(fzf --version | head -n 1)"

command -v eza >/dev/null || (echo "[-] FAIL: eza binary not found in PATH" && exit 1)
echo "  ✓ eza: $(eza --version | head -n 1)"

(command -v bat >/dev/null || command -v batcat >/dev/null) || (echo "[-] FAIL: bat binary not found in PATH" && exit 1)
echo "  ✓ bat: $(command -v bat || command -v batcat)"

# 2. Check Starship Config Syntax
echo "[TEST 2/5] Validating deployed Starship configuration..."
[ -f "$HOME/.config/starship.toml" ] || (echo "[-] FAIL: ~/.config/starship.toml is missing" && exit 1)
STARSHIP_CONFIG="$HOME/.config/starship.toml" starship print-config > /dev/null
echo "  ✓ starship.toml exists and passes full syntax validation."

# 3. Check Mandatory Fonts
echo "[TEST 3/5] Checking font installation..."
if [ -d "$HOME/.local/share/fonts/NerdFonts" ]; then
    ls "$HOME/.local/share/fonts/NerdFonts" | grep -qiE "Hack|FiraCode" || (echo "[-] FAIL: Hack/FiraCode fonts missing in ~/.local/share/fonts/NerdFonts" && exit 1)
    echo "  ✓ Hack / FiraCode font files are present in ~/.local/share/fonts/NerdFonts."
elif command -v fc-list &>/dev/null && fc-list : family | grep -qiE "Hack.*Nerd|FiraCode.*Nerd"; then
    echo "  ✓ Hack / FiraCode Nerd Fonts detected via fc-list."
else
    echo "[-] FAIL: No Hack or FiraCode Nerd Font found"
    exit 1
fi

# 4. Check Shell Profile Injections
echo "[TEST 4/5] Verifying shell profile hooks and aliases..."
if [ -f "$HOME/.bashrc" ]; then
    grep -q 'starship init bash' "$HOME/.bashrc" || (echo "[-] FAIL: starship hook missing from ~/.bashrc" && exit 1)
    grep -q 'zoxide init bash' "$HOME/.bashrc" || (echo "[-] FAIL: zoxide hook missing from ~/.bashrc" && exit 1)
    grep -q 'fzf' "$HOME/.bashrc" || (echo "[-] FAIL: fzf hook missing from ~/.bashrc" && exit 1)
    grep -q 'alias ls=.*eza' "$HOME/.bashrc" || (echo "[-] FAIL: eza alias missing from ~/.bashrc" && exit 1)
    grep -q 'alias cat=.*bat' "$HOME/.bashrc" || (echo "[-] FAIL: bat alias missing from ~/.bashrc" && exit 1)
    echo "  ✓ Bash profile verified."
fi

if [ -f "$HOME/.zshrc" ]; then
    grep -q 'starship init zsh' "$HOME/.zshrc" || (echo "[-] FAIL: starship hook missing from ~/.zshrc" && exit 1)
    grep -q 'zoxide init zsh' "$HOME/.zshrc" || (echo "[-] FAIL: zoxide hook missing from ~/.zshrc" && exit 1)
    echo "  ✓ Zsh profile verified."
fi

if [ -f "$HOME/.config/fish/config.fish" ]; then
    grep -q 'starship init fish' "$HOME/.config/fish/config.fish" || (echo "[-] FAIL: starship hook missing from config.fish" && exit 1)
    echo "  ✓ Fish profile verified."
fi

# 5. Test Idempotency
echo "[TEST 5/5] Testing idempotence (second execution)..."
BASHRC_SUM_1=$(sha256sum "$HOME/.bashrc" 2>/dev/null || true)
ZSHRC_SUM_1=$(sha256sum "$HOME/.zshrc" 2>/dev/null || true)
FISH_SUM_1=$(sha256sum "$HOME/.config/fish/config.fish" 2>/dev/null || true)

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
bash "$REPO_DIR/dotfiles/setup_starship.sh" > /dev/null

BASHRC_SUM_2=$(sha256sum "$HOME/.bashrc" 2>/dev/null || true)
ZSHRC_SUM_2=$(sha256sum "$HOME/.zshrc" 2>/dev/null || true)
FISH_SUM_2=$(sha256sum "$HOME/.config/fish/config.fish" 2>/dev/null || true)

[ "$BASHRC_SUM_1" = "$BASHRC_SUM_2" ] || (echo "[-] FAIL: ~/.bashrc modified during 2nd execution (not idempotent)" && exit 1)
[ "$ZSHRC_SUM_1" = "$ZSHRC_SUM_2" ] || (echo "[-] FAIL: ~/.zshrc modified during 2nd execution (not idempotent)" && exit 1)
[ "$FISH_SUM_1" = "$FISH_SUM_2" ] || (echo "[-] FAIL: config.fish modified during 2nd execution (not idempotent)" && exit 1)
echo "  ✓ Idempotency confirmed: all profiles unchanged on second run."

echo "========================================="
echo " 🏆 ALL TESTS PASSED!"
echo "========================================="
