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

#### Exclusive Guide for the Local Agent (Scar):
- To synchronize local changes from this machine into the repository before pushing:
  ```bash
  ./scripts/sync_starship_local.sh
  ```
- To publish updates to the remote repository:
  ```bash
  git add . && git commit -m "update: sync starship.toml" && git push origin main
  ```
- **Cleanliness Note:** The local sync script `scripts/sync_starship_local.sh` and administrator guide stay exclusively in this internal document (`docs/fedora_maintenance.md`) and the ignored `scripts/` folder, without cluttering the public `README.md`.

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
   - **Bash:** Moved user PATHs and `EDITOR`/`VISUAL=vim` before the AI Agent guard so agent subshells have full access to `~/.local/bin`, Homebrew, Go, Bun, and CUDA.
   - **Fish:** Switched Bun to `fish_add_path` to prevent path duplication across subshells; cleaned up purged Snap path; aligned AI agent guard to check both `ANTIGRAVITY_AGENT` and `AI_AGENT`.
   - **Zsh:** Removed purged Snap path; integrated CUDA and Bun into PATH; updated AI agent guard to support both `ANTIGRAVITY_AGENT` and `AI_AGENT`; set `VISUAL=vim`.
   - **PowerShell:** Integrated AI agent guard, `~/.local/bin` PATH check, CUDA paths, and `eza`/`bat` aliases functions.
   - **CUDA:** Configured shells to reference `/usr/local/cuda` (active symlink for CUDA 13.1) with fallback.
