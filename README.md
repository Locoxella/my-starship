# 🚀 Starship Prompt Setup & Auto-Configurator

Repositorio maestro y fuente de la verdad para la configuración de **Starship Prompt** (`starship.toml`) y scripts de despliegue automatizados para cualquier sistema operativo y shell.

<p align="center">
  <img src="assets/prompt_preview.svg" alt="Starship Prompt Preview" width="100%">
</p>

---

## 📋 Prompt listo para copiar a tu Agente de IA (1-Click Copy)

Copia y pega este prompt directamente en el agente de IA que esté ejecutando en tu otra máquina (Cursor, Windsurf, Claude Code, ChatGPT, Gemini, Copilot, Aider, etc.):

```text
Configura Starship prompt en esta máquina siguiendo las instrucciones de https://raw.githubusercontent.com/Locoxella/my-starship/main/README.md
Detecta el sistema operativo y todos los shells instalados, ejecuta el instalador automatizado correspondiente (o sigue el protocolo paso a paso si hay restricciones en la terminal), aplica la configuración personalizada de starship.toml y recuérdame qué Nerd Font necesito para que los glifos de la terminal se vean correctamente.
```

*(English version)*:
```text
Configure Starship prompt on this machine following the instructions at https://raw.githubusercontent.com/Locoxella/my-starship/main/README.md
Detect the OS and all installed shells, execute the corresponding one-line automated installer (or the step-by-step protocol if network piping is restricted), deploy the custom starship.toml config, and remind me which Nerd Font to configure in my terminal so all prompt glyphs render properly.
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

---

## 🔤 Font Requirement: Nerd Fonts

This custom configuration heavily relies on Powerline glyphs and symbols (``, ``, ``, git symbols, OS icons).
If icons look broken or appear as square boxes / question marks:

- **Windows (Winget):**
  ```powershell
  winget install -e --id NerdFonts.JetBrainsMono
  ```
- **Linux / macOS (Automated Script):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/install_nerd_font.sh | bash
  ```
- **Manual Download:** [nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads) (recommended: *JetBrains Mono Nerd Font*, *FiraCode Nerd Font*, or *MesloLGS NF*).

> **Important:** Remember to select the installed Nerd Font in your terminal emulator settings (Windows Terminal, VS Code, Kitty, Alacritty, iTerm2, WezTerm).

---

## 🎬 Terminal Session Recording (VHS)

The repository includes a [VHS](https://github.com/charmbracelet/vhs) tape configuration in [`assets/demo.tape`](assets/demo.tape). You can generate an animated demo GIF anytime by running:
```bash
vhs assets/demo.tape
```

---

## 💬 Agent Final Checklist & Feedback

After installation, the AI agent should:
1. ✅ Report which shells were successfully configured.
2. 🔄 Instruct the user to restart their terminal session or source their shell profile.
3. 🔤 Remind the user about the Nerd Font requirement if not already set up.
4. 💡 If any unsupported environment or issue was encountered, output suggested improvements so the user can report them back to the repository maintainer.
