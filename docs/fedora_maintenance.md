# Fedora Maintenance Record - Laptop Scar

## History of Modifications & Fixes

### [2026-07-25] KDE Discover Repair & Snap Removal

#### Technical Diagnosis

* **Symptom:** KDE Discover froze indefinitely when checking for or applying updates.
* **Root Cause:**
  1. `discover-backend-snap` was blocking the UI thread while waiting for D-Bus responses from `snapd`.
  2. Security incompatibility: Fedora runs SELinux by default while Snap requires AppArmor (inactive on Fedora), causing continuous timeouts in `snapd.service`.
  3. Resource waste: The Snap daemon consumed ~1GB of RAM keeping mounted multiple base virtual environments (`core`, `core18`, `core22`, `gnome-3-26-1604`, `gnome-42-2204`).

#### Solution Applied

1. Removed user-installed Snap packages (`qr-code-generator-desktop`).
2. Verified native replacements: `Qrca` (`org.kde.qrca` on Flatpak) is now active as replacement.
3. Created executable script `scripts/maintenance/remove_snap.sh` to purge `snapd` and `discover-backend-snap` RPM packages.

---

### [2026-07-30] Local Maintenance of `my-starship` (Single Source of Truth)

This computer (`Scar`) is the **single source of truth** for the Starship configuration (`~/.config/starship.toml`).

#### Exclusive Guide for the Local Agent (Scar)

* To synchronize local changes from this machine into the repository before pushing:

  ```bash
  ./scripts/sync_starship_local.sh
  ```

* To publish updates to the remote repository:

  ```bash
  git add . && git commit -m "update: sync starship.toml" && git push origin main
  ```

* **Cleanliness Note:** The local sync script `scripts/sync_starship_local.sh` and administrator guide stay exclusively in this internal document (`docs/fedora_maintenance.md`) and the ignored `scripts/` folder, without cluttering the public `README.md`.

---

### [2026-09-10] AI Agent Optimization & Visual Preview

1. **1-Click Prompt:** Added code block with clipboard-ready prompt wrapped at column 40 in `README.md`.
2. **URL Fixes:** Corrected obsolete `Locoxella/scar` references in `dotfiles/setup_starship.ps1`.
3. **Clear Protocol Mapping:** Explicitly defined Express Mode (1-liners) and Step-by-Step Mode for restricted terminals.
4. **Nerd Font Detection & Helper:** Added automated font detection in setup scripts and created `dotfiles/install_nerd_font.sh`.
5. **Visual Previews:** Created SVG vector preview and VHS `.tape` demo script.

---

### [2026-10-11] Multi-Shell Harmonization & Starship Shell Indicators

1. **Starship Configuration:** Added `powershell_indicator`, `cmd_indicator`, `nu_indicator`, and `unknown_indicator` to `dotfiles/starship.toml` and synchronized with `~/.config/starship.toml`.
2. **Setup Scripts:** Added interactive guards (`[[ $- == *i* ]]` and `$Host.UI.RawUI.KeyAvailable`) to prevent Starship execution during non-interactive automated subshells in Bash, Zsh, and PowerShell.
3. **Local Shells Harmonization:**
   * **Bash:** Moved user PATHs and `EDITOR`/`VISUAL=vim` before the AI Agent guard so agent subshells have full access to `~/.local/bin`, Homebrew, Go, Bun, and CUDA.
   * **Fish:** Switched Bun to `fish_add_path` to prevent path duplication across subshells; cleaned up purged Snap path; aligned AI agent guard to check both `ANTIGRAVITY_AGENT` and `AI_AGENT`.
   * **Zsh:** Removed purged Snap path; integrated CUDA and Bun into PATH; updated AI agent guard to support both `ANTIGRAVITY_AGENT` and `AI_AGENT`; set `VISUAL=vim`.
   * **PowerShell:** Integrated AI agent guard, `~/.local/bin` PATH check, CUDA paths, and `eza`/`bat` aliases functions.
   * **CUDA:** Configured shells to reference `/usr/local/cuda` (active symlink for CUDA 13.1) with fallback.

---

### [2026-10-13] Optional CLI Tools (Glow) & KDE Plasma Fixed Font Integration

1. **Optional Tool Integration (`glow`):**
   - Configured cross-shell handling for markdown files (`glow -p`) across Bash (`command_not_found_handle`), Zsh (`alias -s md/markdown`), Fish (`auto_glow.fish` with enter hook), and PowerShell (`CommandNotFoundAction` / PSReadLine enter key handler).
   - Injected conditional setup in `dotfiles/setup_starship.sh` and `dotfiles/setup_starship.ps1`.
2. **KDE Plasma System-Wide Font Configuration:**
   - Added KDE Plasma tip in `dotfiles/install_nerd_font.sh` and `README.md` to configure `Hack Nerd Font Mono` as the system-wide fixed-width font (`kwriteconfig6` / `kwriteconfig5` on `kdeglobals`), ensuring terminals without explicit font pickers correctly display Nerd Font symbols.
3. **Documentation:**
   - Updated `README.md` with optional CLI enhancements section and KDE configuration tip.

---

### [2026-10-31] PowerShell Guard Fix, Multi-Architecture Support, Nushell & Gitignore Standardization

1. **PowerShell Interactivity Guard Fix:**
   - Replaced `$Host.UI.RawUI.KeyAvailable` with `-not [Console]::IsInputRedirected` across `dotfiles/setup_starship.sh`, `dotfiles/setup_starship.ps1`, and local `~/.config/powershell/Microsoft.PowerShell_profile.ps1`.
   - Prevented Starship initialization failure in interactive PowerShell consoles caused by checking the keyboard buffer.
2. **Automated Verification Test Suite:**
   - Enhanced `tests/verify_installation.sh` to assert that the PowerShell prompt is actually configured by Starship (`STARSHIP_SHELL` / prompt definition match) rather than testing the built-in default PowerShell `prompt`.
3. **Multi-Architecture & macOS Support:**
   - Added Linux `aarch64` (ARM64) support for `bat` binary downloads in `dotfiles/setup_starship.sh`.
   - Added Darwin (macOS) fallback for `bat` and `eza` via Homebrew (`brew install`).
4. **Nushell Integration:**
   - Added automatic Starship configuration for Nushell (`nu`) in `dotfiles/setup_starship.sh`.
5. **Catppuccin Theme Switcher:**
   - Added `scripts/switch_theme.sh` allowing instant switching between Catppuccin flavors (`mocha`, `latte`, `frappe`, `macchiato`).
6. **Gitignore Standardization:**
   - Replaced minimal ad-hoc `.gitignore` with standard Toptal gitignore.io baseline (Linux, macOS, Windows, VS Code, JetBrains, PowerShell) and preserved custom rules.
>>>>>>> 5fc96d1 (feat: fix PowerShell guard, add ARM64/Nushell support, update fonts, and add ShellCheck CI)
