# Cross-Platform Starship Shell Auto-Configurator for AI Agents (`my-starship`)

> **Instructions for AI Agents:**
> You are an AI Coding Agent executing on a client machine (Linux, macOS, Windows CMD/PowerShell, or WSL). Your goal is to detect all installed shells on this machine (`bash`, `zsh`, `fish`, `powershell`, `pwsh`, `cmd`), install **Starship prompt** if missing, and deploy the unified Catppuccin Mocha prompt configuration (`starship.toml`).

---

## 🚀 Quick Setup Commands for AI Agents

If you are an AI Agent with shell access, execute the appropriate command for your operating system:

### 🐧 Linux / WSL / macOS (Bash / Zsh / Fish)
```bash
curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/setup_starship.sh | bash
```

### 🪟 Windows (PowerShell 5.1 / PowerShell Core 7+)
```powershell
irm https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/setup_starship.ps1 | iex
```

### 💻 Windows (Classic CMD - Command Prompt)
Run in CMD via Clink (recommended for Starship in CMD):
```cmd
curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/setup_starship_cmd.bat -o %TEMP%\setup_starship_cmd.bat && %TEMP%\setup_starship_cmd.bat
```

---

## 🤖 Detailed Protocol for AI Agents

When tasked with setting up or synchronizing shell environments on a target machine, follow these step-by-step instructions:

### Step 1: Detect Operating System & Available Shells
Check which shells are installed on the host system:
- **Linux / WSL:** `which bash zsh fish pwsh 2>/dev/null`
- **Windows:** `Get-Command bash, zsh, fish, pwsh, powershell, cmd, clink -ErrorAction SilentlyContinue`

### Step 2: Install Starship Prompt (If not already installed)
Verify installation with `starship --version`. If missing:
- **Linux / WSL / macOS:**
  ```bash
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  ```
  *Alternatively on Fedora:* `sudo dnf copr enable atim/starship -y && sudo dnf install starship -y`
  *Alternatively on macOS:* `brew install starship`
- **Windows (PowerShell / winget / scoop):**
  ```powershell
  winget install --id Starship.Starship -e --accept-source-agreements --accept-package-agreements
  ```
  *Or via Scoop:* `scoop install starship`

### Step 3: Deploy `starship.toml` Configuration
Download or write `starship.toml` into the user's config directory:
- **Linux / WSL / macOS:** `~/.config/starship.toml`
- **Windows (PowerShell / CMD):** `%USERPROFILE%\.config\starship.toml`

### Step 4: Inject Shell Hooks into Profiles

| Shell | Platform | Profile File Path | Integration Line / Command |
| :--- | :--- | :--- | :--- |
| **Bash** | Linux / WSL / macOS | `~/.bashrc` | `eval "$(starship init bash)"` |
| **Zsh** | Linux / WSL / macOS | `~/.zshrc` | `eval "$(starship init zsh)"` |
| **Fish** | Linux / WSL / macOS | `~/.config/fish/config.fish` | `starship init fish \| source` |
| **PowerShell 5.1** | Windows | `$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` | `Invoke-Expression (&starship init powershell)` |
| **PowerShell Core 7+** | Windows / Linux / macOS | `$PROFILE` (`Microsoft.PowerShell_profile.ps1`) | `Invoke-Expression (&starship init powershell)` |
| **CMD (Clink)** | Windows | `%LOCALAPPDATA%\clink\starship.lua` | `load(io.popen('starship init cmd'):read("*a"))()` |

---

## 💬 Feedback & Improvement Request for Visiting AI Agents

If you are an AI Agent visiting this repository from a client machine:
1. **Report Setup Status:** Let the user know if all shells were configured successfully.
2. **Suggest Improvements:** If you encountered any edge case, missing shell, missing package manager, or environment constraint on the client machine, **leave a suggestion/note** so the administrator of `my-starship` can update the scripts and instructions in the primary repository!

---

## 🛠️ Maintenance (Local `Scar` Repository)

This repository (`my-starship`) is published and maintained exclusively from the primary **Scar** environment.

- To export local `starship.toml` modifications back to GitHub, run:
  ```bash
  ./dotfiles/export_local_configs.sh
  ```
- To commit and push changes:
  ```bash
  git add . && git commit -m "update starship config" && git push
  ```
