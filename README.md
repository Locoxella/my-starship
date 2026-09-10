# 🚀 Starship Prompt Setup & Auto-Configurator

Master repository and single source of truth for **Starship Prompt** configuration (`starship.toml`) and automated deployment scripts across all operating systems and shells.

<p align="center">
  <img src="assets/prompt_preview.svg" alt="Starship Prompt Preview" width="100%">
</p>

---

## 📋 1-Click Prompt for your AI Agent

Copy and paste this prompt directly into the AI agent running on your target machine (Cursor, Windsurf, Claude Code, ChatGPT, Gemini, Copilot, Aider, etc.):

```text
Configure Starship prompt on this machine
following instructions at:
https://raw.githubusercontent.com/Locoxella/my-starship/main/README.md

Detect OS and shells. Run the automated
installer, which also installs the required
Hack & FiraCode Nerd Fonts if missing.

Deploy the custom starship.toml config
and remind me to select Hack Nerd Font
in my terminal emulator settings.
```

---

## 🤖 Instructions for Visiting AI Agents

You are an AI Agent tasked with configuring the prompt on the client machine where you are currently running.

### Execution Workflow:
1. **Choose your execution path:**
   - **Mode A (Preferred / Express):** If you can execute shell commands with internet access, run the **Quick One-Line Automated Installer** for the detected OS. The scripts automatically detect installed shells, install Starship, copy the configuration, and configure profile files.
   - **Mode B (Manual / Audited Protocol):** If network piping (`curl | bash` or `irm | iex`) is restricted or forbidden by your security policy, follow the **Step-by-Step AI Agent Execution Protocol** below.
2. **Verify & Inform:**
   - Confirm which shells were successfully configured.
   - Run `starship --version` to confirm binary availability.
   - Remind the user to reload the active terminal (`source ~/.bashrc`, restart PowerShell, etc.).
   - **Crucial:** Advise the user to configure a **Nerd Font** in their terminal application (e.g. Windows Terminal, Alacritty, Kitty, iTerm2, WezTerm) so all icons and Powerline glyphs (``, ``, ``, git symbols, OS logos) render correctly without missing-character boxes.

---

## ⚡ Mode A: Quick One-Line Automated Installers

Execute the command matching the client platform:

### 🐧 Linux / WSL / macOS (Bash, Zsh, Fish, Pwsh)
```bash
curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/setup_starship.sh | bash
```

### 🪟 Windows (PowerShell 5.1 & PowerShell Core 7+)
```powershell
irm https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/setup_starship.ps1 | iex
```

### 💻 Windows (CMD - Command Prompt via Clink)
```cmd
curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/setup_starship_cmd.bat -o %TEMP%\setup_starship_cmd.bat && %TEMP%\setup_starship_cmd.bat
```

---

## 📖 Mode B: Step-by-Step AI Agent Execution Protocol

Use this mode when you need to inspect or execute each step individually.

### Step 1: Detect System & Shells
- **Linux/WSL/macOS:** Run `which bash zsh fish pwsh 2>/dev/null`
- **Windows:** Run `Get-Command bash, zsh, fish, pwsh, powershell, cmd, clink -ErrorAction SilentlyContinue`

### Step 2: Install Starship Binary
- **Linux/WSL/macOS:**
  ```bash
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  ```
- **Windows (winget):**
  ```powershell
  winget install --id Starship.Starship -e --accept-source-agreements --accept-package-agreements
  ```
- **Windows (scoop fallback):**
  ```powershell
  scoop install starship
  ```

### Step 3: Deploy Configuration File
Download `dotfiles/starship.toml` to:
- **Linux / WSL / macOS:** `~/.config/starship.toml`
  ```bash
  mkdir -p ~/.config && curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/starship.toml -o ~/.config/starship.toml
  ```
- **Windows:** `%USERPROFILE%\.config\starship.toml`
  ```powershell
  New-Item -ItemType Directory -Path "$HOME\.config" -Force | Out-Null
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/starship.toml" -OutFile "$HOME\.config\starship.toml"
  ```

### Step 4: Inject Init Hook into Shell Profiles

Append the hook if not already present in the target profile file:

| Shell | Platform | Target File | Integration Code |
| :--- | :--- | :--- | :--- |
| **Bash** | Linux / WSL / macOS | `~/.bashrc` | `eval "$(starship init bash)"` |
| **Zsh** | Linux / WSL / macOS | `~/.zshrc` | `eval "$(starship init zsh)"` |
| **Fish** | Linux / WSL / macOS | `~/.config/fish/config.fish` | `starship init fish \| source` |
| **PowerShell 5.1** | Windows | `$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` | `Invoke-Expression (&starship init powershell)` |
| **PowerShell Core 7+** | Windows / Linux / macOS | `$PROFILE` (`Microsoft.PowerShell_profile.ps1`) | `Invoke-Expression (&starship init powershell)` |
| **CMD (Clink)** | Windows | `%LOCALAPPDATA%\clink\starship.lua` | `load(io.popen('starship init cmd'):read("*a"))()` |

### Step 5: Install Mandatory Fonts (Hack & FiraCode Nerd Fonts)

A Nerd Font is strictly required to render Powerline symbols (``, ``, ``), Git status, and OS logos:
- **Hack Nerd Font:** Designated font for your terminal emulator / console.
- **FiraCode Nerd Font:** Installed for VS Code and code editors.

Execute the font installer for the target OS:
- **Linux / macOS:**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/install_nerd_font.sh | bash
  ```
- **Windows (Winget):**
  ```powershell
  winget install -e --id NerdFonts.Hack && winget install -e --id NerdFonts.FiraCode
  ```

### Step 6: Reload Terminal & Apply Font Settings
1. **Reload Shell:** Run `source ~/.bashrc` (or restart PowerShell / CMD).
2. **Set Terminal Font:** Open terminal preferences (Windows Terminal, VS Code, Kitty, Alacritty, iTerm2, WezTerm) and select **Hack Nerd Font** as the font family.

---

## 💬 Visiting Agent Final Checklist

After completing the installation on the client machine, the AI agent should:
1. ✅ Confirm which shells were successfully configured.
2. ✅ Confirm that Starship and Hack/FiraCode Nerd Fonts are installed.
3. 🔄 Instruct the user to restart their terminal session or source their shell profile.
4. 🔤 Remind the user to select **Hack Nerd Font** in their terminal emulator settings.
5. 💡 If any unsupported environment was encountered, report suggested improvements to the maintainer.
