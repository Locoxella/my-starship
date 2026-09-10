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
