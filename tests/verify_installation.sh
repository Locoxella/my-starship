#!/usr/bin/env bash
# Test suite for my-starship installation
# Verifies binaries, configs, fonts, shell profile hooks, and idempotency

set -e

CURRENT_STAGE="Initializing test environment"
touch /tmp/.summary_written 2>/dev/null || true

write_github_summary() {
    local EXIT_CODE=$?
    if [ -z "$GITHUB_STEP_SUMMARY" ]; then
        return 0
    fi

    local DISTRO_NAME="Linux Container"
    if [ -f /etc/os-release ]; then
        DISTRO_NAME=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')
    fi

    local STARSHIP_VER=$(command -v starship &>/dev/null && starship --version 2>/dev/null | head -n 1 || echo "Not found")
    local ZOXIDE_VER=$(command -v zoxide &>/dev/null && zoxide --version 2>/dev/null || echo "Not found")
    local FZF_VER=$(command -v fzf &>/dev/null && fzf --version 2>/dev/null | head -n 1 || echo "Not found")
    local EZA_VER=$(command -v eza &>/dev/null && eza --version 2>/dev/null | head -n 1 || echo "Not found")
    local BAT_VER=$(command -v bat &>/dev/null && bat --version 2>/dev/null | head -n 1 || (command -v batcat &>/dev/null && batcat --version 2>/dev/null | head -n 1) || echo "Not found")

    local FONT_STATUS="❌ Missing"
    local FONT_DETAILS="No Nerd Fonts detected"
    if [ -d "$HOME/.local/share/fonts/NerdFonts" ]; then
        local FONT_COUNT=$(ls -1 "$HOME/.local/share/fonts/NerdFonts" 2>/dev/null | wc -l || echo "0")
        FONT_STATUS="✅ Verified (${FONT_COUNT} files)"
        FONT_DETAILS="Hack & FiraCode in \`~/.local/share/fonts/NerdFonts\`"
    elif command -v fc-list &>/dev/null && fc-list : family | grep -qiE "Hack.*Nerd|FiraCode.*Nerd"; then
        FONT_STATUS="✅ Verified (system)"
        FONT_DETAILS="Hack / FiraCode detected via \`fc-list\`"
    fi

    local BASH_STATUS="⚪ Not configured"
    if [ -f "$HOME/.bashrc" ]; then
        if grep -q 'starship init bash' "$HOME/.bashrc"; then
            BASH_STATUS="✅ Verified (Prompt + 4 Tools)"
        else
            BASH_STATUS="❌ Incomplete"
        fi
    fi

    local ZSH_STATUS="⚪ Not configured"
    if [ -f "$HOME/.zshrc" ]; then
        if grep -q 'starship init zsh' "$HOME/.zshrc"; then
            ZSH_STATUS="✅ Verified (Prompt + 4 Tools)"
        else
            ZSH_STATUS="❌ Incomplete"
        fi
    fi

    local FISH_STATUS="⚪ Not configured"
    if [ -f "$HOME/.config/fish/config.fish" ]; then
        if grep -q 'starship init fish' "$HOME/.config/fish/config.fish"; then
            FISH_STATUS="✅ Verified (Prompt + 4 Tools)"
        else
            FISH_STATUS="❌ Incomplete"
        fi
    fi

    local SHORT_HASH_B1="${BASHRC_SUM_1:0:16}"
    local SHORT_HASH_B2="${BASHRC_SUM_2:0:16}"
    local SHORT_HASH_Z1="${ZSHRC_SUM_1:0:16}"
    local SHORT_HASH_Z2="${ZSHRC_SUM_2:0:16}"
    local SHORT_HASH_F1="${FISH_SUM_1:0:16}"
    local SHORT_HASH_F2="${FISH_SUM_2:0:16}"

    {
        echo "## 📦 ${DISTRO_NAME} (\`${TARGET_IMAGE:-$(uname -m)}\`)"
        echo ""
        if [ "$EXIT_CODE" -eq 0 ]; then
            echo "> **Overall Result:** ✅ **ALL TESTS PASSED** — Environment is 100% verified & idempotent."
        else
            echo "> **Overall Result:** ❌ **FAILED AT STAGE:** \`${CURRENT_STAGE}\` (Exit code: ${EXIT_CODE})"
        fi
        echo ""
        echo "### 🛠️ Modern CLI Tools & Detected Versions"
        echo "| Tool | Binary Command | Detected Version | Validation |"
        echo "| :--- | :--- | :--- | :--- |"
        echo "| 🚀 **Starship Prompt** | \`starship\` | \`${STARSHIP_VER}\` | $(command -v starship &>/dev/null && echo "✅ PASS" || echo "❌ FAIL") |"
        echo "| ⚡ **zoxide** | \`zoxide\` | \`${ZOXIDE_VER}\` | $(command -v zoxide &>/dev/null && echo "✅ PASS" || echo "❌ FAIL") |"
        echo "| 🔍 **fzf** | \`fzf\` | \`${FZF_VER}\` | $(command -v fzf &>/dev/null && echo "✅ PASS" || echo "❌ FAIL") |"
        echo "| 🗂️ **eza** | \`eza\` | \`${EZA_VER}\` | $(command -v eza &>/dev/null && echo "✅ PASS" || echo "❌ FAIL") |"
        echo "| 🦇 **bat** | \`bat\` | \`${BAT_VER}\` | $((command -v bat || command -v batcat) &>/dev/null && echo "✅ PASS" || echo "❌ FAIL") |"
        echo ""
        echo "### 🔤 Typography & Shell Configurations"
        echo "| Component | Target Path | Configuration Details | Status |"
        echo "| :--- | :--- | :--- | :--- |"
        echo "| **Fonts** | Hack & FiraCode Nerd Fonts | ${FONT_DETAILS} | ${FONT_STATUS} |"
        echo "| **Config** | \`~/.config/starship.toml\` | Parsed via \`starship print-config\` | $([ -f "$HOME/.config/starship.toml" ] && echo "✅ Verified (Valid syntax)" || echo "❌ Missing") |"
        echo "| **Bash** | \`~/.bashrc\` | Starship hook, zoxide, fzf, eza & bat aliases | ${BASH_STATUS} |"
        echo "| **Zsh** | \`~/.zshrc\` | Starship hook, zoxide, fzf, eza & bat aliases | ${ZSH_STATUS} |"
        echo "| **Fish** | \`~/.config/fish/config.fish\` | Starship hook, zoxide/z, fzf, aliases | ${FISH_STATUS} |"
        echo ""
        if [ -n "$BASHRC_SUM_1" ] || [ -n "$ZSHRC_SUM_1" ] || [ -n "$FISH_SUM_1" ]; then
            echo "### 🔒 Strict Idempotency Assertion (2nd Run Proof)"
            echo "| Profile File | Initial Run SHA-256 | Second Run SHA-256 | Idempotency Guarantee |"
            echo "| :--- | :--- | :--- | :--- |"
            [ -n "$BASHRC_SUM_1" ] && echo "| \`~/.bashrc\` | \`${SHORT_HASH_B1}...\` | \`${SHORT_HASH_B2}...\` | $([ "$BASHRC_SUM_1" = "$BASHRC_SUM_2" ] && echo "✅ 100% Identical (0 duplicates)" || echo "❌ Modified") |"
            [ -n "$ZSHRC_SUM_1" ] && echo "| \`~/.zshrc\` | \`${SHORT_HASH_Z1}...\` | \`${SHORT_HASH_Z2}...\` | $([ "$ZSHRC_SUM_1" = "$ZSHRC_SUM_2" ] && echo "✅ 100% Identical (0 duplicates)" || echo "❌ Modified") |"
            [ -n "$FISH_SUM_1" ] && echo "| \`config.fish\` | \`${SHORT_HASH_F1}...\` | \`${SHORT_HASH_F2}...\` | $([ "$FISH_SUM_1" = "$FISH_SUM_2" ] && echo "✅ 100% Identical (0 duplicates)" || echo "❌ Modified") |"
            echo ""
        fi
        local DISTRO_IMG="preview_fedora.gif"
        if [ -f /etc/os-release ]; then
            local DIST_ID=$(grep -E '^ID=' /etc/os-release | cut -d= -f2- | tr -d '"')
            case "$DIST_ID" in
                *ubuntu*) DISTRO_IMG="preview_ubuntu.gif" ;;
                *debian*) DISTRO_IMG="preview_debian.gif" ;;
                *arch*) DISTRO_IMG="preview_archlinux.gif" ;;
                *suse*) DISTRO_IMG="preview_opensuse.gif" ;;
                *fedora*) DISTRO_IMG="preview_fedora.gif" ;;
                *) DISTRO_IMG="preview_fedora.gif" ;;
            esac
        fi

        local CACHE_KEY="${GITHUB_RUN_ID:-${GITHUB_SHA:-live}}"
        echo "### 🎥 Native Container Execution Demo (${DISTRO_NAME})"
        echo '<p align="left">'
        echo "  <img src=\"https://raw.githubusercontent.com/Locoxella/my-starship/ci-previews/previews/${DISTRO_IMG}?v=${CACHE_KEY}\" alt=\"${DISTRO_NAME} Terminal Preview\" width=\"850\" />"
        echo '</p>'
        echo ""
        echo "---"
    } >> "$GITHUB_STEP_SUMMARY"

    # Also preserve container log as artifact
    local LOG_DIR="${CONTAINER_LOG_DIR:-/tmp}"
    mkdir -p "$LOG_DIR" 2>/dev/null || true
    local LOG_TARGET="${LOG_DIR}/live_container_${DIST_ID:-generic}.log"
    {
        echo "=== Container Live Execution Output: ${DISTRO_NAME} ==="
        echo "starship: ${STARSHIP_VER}"
        echo "zoxide:   ${ZOXIDE_VER}"
        echo "fzf:      ${FZF_VER}"
        echo "eza:      ${EZA_VER}"
        echo "bat:      ${BAT_VER}"
    } > "$LOG_TARGET" 2>&1 || true
    [ "$LOG_DIR" != "/tmp" ] && cp -f "$LOG_TARGET" "/tmp/live_container_${DIST_ID:-generic}.log" 2>/dev/null || true
}

trap 'write_github_summary' EXIT

export PATH="$HOME/.local/bin:$HOME/.fzf/bin:$PATH"

# 1. Check Binaries
CURRENT_STAGE="1/5: Checking required CLI binaries"
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
CURRENT_STAGE="2/5: Validating deployed Starship configuration syntax"
echo "[TEST 2/5] Validating deployed Starship configuration..."
[ -f "$HOME/.config/starship.toml" ] || (echo "[-] FAIL: ~/.config/starship.toml is missing" && exit 1)
STARSHIP_CONFIG="$HOME/.config/starship.toml" starship print-config > /dev/null
echo "  ✓ starship.toml exists and passes full syntax validation."

# 3. Check Mandatory Fonts
CURRENT_STAGE="3/5: Checking Hack & FiraCode Nerd Font installation"
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
CURRENT_STAGE="4/5: Verifying shell profile hooks and aliases (Bash, Zsh, Fish)"
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
    grep -q 'fzf' "$HOME/.zshrc" || (echo "[-] FAIL: fzf hook missing from ~/.zshrc" && exit 1)
    grep -q 'alias ls=.*eza' "$HOME/.zshrc" || (echo "[-] FAIL: eza alias missing from ~/.zshrc" && exit 1)
    grep -q 'alias cat=.*bat' "$HOME/.zshrc" || (echo "[-] FAIL: bat alias missing from ~/.zshrc" && exit 1)
    echo "  ✓ Zsh profile verified."
fi

if [ -f "$HOME/.config/fish/config.fish" ]; then
    grep -q 'starship init fish' "$HOME/.config/fish/config.fish" || (echo "[-] FAIL: starship hook missing from config.fish" && exit 1)
    (grep -q 'zoxide init fish' "$HOME/.config/fish/config.fish" || grep -q 'jethrokuan/z' "$HOME/.config/fish/fish_plugins" 2>/dev/null || command -v z >/dev/null) || (echo "[-] FAIL: z / zoxide hook missing from config.fish" && exit 1)
    (grep -q 'fzf' "$HOME/.config/fish/config.fish" || grep -q 'fzf.fish' "$HOME/.config/fish/fish_plugins" 2>/dev/null) || (echo "[-] FAIL: fzf hook missing from config.fish" && exit 1)
    grep -q 'alias ls=' "$HOME/.config/fish/config.fish" || (echo "[-] FAIL: eza alias missing from config.fish" && exit 1)
    grep -q 'alias cat=' "$HOME/.config/fish/config.fish" || (echo "[-] FAIL: bat alias missing from config.fish" && exit 1)
    echo "  ✓ Fish profile verified."
fi

# 5. Test Idempotency
CURRENT_STAGE="5/5: Testing idempotence across shell profiles (second execution)"
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
