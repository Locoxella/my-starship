# Cross-Platform Starship Shell Auto-Configurator for AI Agents

> **Instructions for AI Agents:**
> You are an AI Coding Agent executing on a client machine (Linux, macOS, Windows PowerShell, or WSL). Your goal is to detect the installed shells on this machine (`bash`, `zsh`, `fish`, `powershell`/`pwsh`), install **Starship prompt** if missing, and deploy the unified Catppuccin Mocha prompt configuration (`starship.toml`).

---

## 🚀 Quick Setup Command for AI Agents

If you are an AI Agent with shell access, execute the appropriate command for your operating system:

### 🐧 Linux / WSL / macOS (Bash / Zsh)
```bash
curl -fsSL https://raw.githubusercontent.com/Locoxella/scar/main/dotfiles/setup_starship.sh | bash
```

### 🪟 Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/Locoxella/scar/main/dotfiles/setup_starship.ps1 | iex
```

---

## 🤖 Detailed Prompt / Protocol for AI Agents

When tasked with setting up or synchronizing shell environments on a target machine, follow these step-by-step instructions:

### Step 1: Detect Operating System & Available Shells
Check which shells are installed on the host system:
- **Linux / WSL:** `which bash zsh fish pwsh 2>/dev/null`
- **Windows:** `Get-Command bash, zsh, fish, pwsh, powershell -ErrorAction SilentlyContinue`

### Step 2: Install Starship Prompt (If not already installed)
Verify installation with `starship --version`. If missing:
- **Linux / WSL / macOS:**
  ```bash
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  ```
  *Alternatively on Fedora:* `sudo dnf copr enable atim/starship -y && sudo dnf install starship -y`
  *Alternatively on Ubuntu/Debian:* `sudo snap install starship` or build/download binary.
  *Alternatively on macOS:* `brew install starship`
- **Windows (PowerShell / winget):**
  ```powershell
  winget install --id Starship.Starship -e --accept-source-agreements --accept-package-agreements
  ```
  *Or via Scoop:* `scoop install starship`

### Step 3: Deploy `starship.toml` Configuration
Download or write `starship.toml` into the user's config directory:
- **Linux / WSL / macOS:** `~/.config/starship.toml`
- **Windows:** `$HOME\.config\starship.toml` (or `$env:APPDATA\starship.toml`)

### Step 4: Inject Shell Hooks into Profiles
Inject the respective `starship init <shell>` line into each active profile if not present:

| Shell | Profile File Path | Integration Line |
| :--- | :--- | :--- |
| **Bash** | `~/.bashrc` | `eval "$(starship init bash)"` |
| **Zsh** | `~/.zshrc` | `eval "$(starship init zsh)"` |
| **Fish** | `~/.config/fish/config.fish` | `starship init fish \| source` |
| **PowerShell** | `$PROFILE` / `Microsoft.PowerShell_profile.ps1` | `Invoke-Expression (&starship init powershell)` |

---

## 🛠️ Repository Contents & Maintenance (Scar Project)

This repository forms part of the **Scar** laptop maintenance and environment synchronization framework.

- `dotfiles/starship.toml`: Primary prompt theme configuration (Catppuccin Mocha palette with cross-shell indicators).
- `dotfiles/setup_starship.sh`: Automated POSIX shell setup script.
- `dotfiles/setup_starship.ps1`: Automated PowerShell setup script.
- `dotfiles/export_local_configs.sh`: Helper script to sync local host configuration back into Scar repo.
