# 🚀 Starship Prompt Setup & Auto-Configurator

Master repository and single source of truth for **Starship Prompt** configuration (`starship.toml`) and automated deployment scripts across all operating systems and shells.

<p align="center">
  <img src="assets/demo.gif" alt="Starship Prompt Animated Demo" width="100%">
</p>

---

## 📋 1-Click Prompt for your AI Agent

Copy and paste this prompt directly into the AI agent running on your target machine (Cursor, Windsurf, Claude Code, ChatGPT, Gemini, Copilot, Aider, etc.):

```text
Configure Starship prompt on this machine
following instructions at:
https://raw.githubusercontent.com/Locoxella/my-starship/main/README.md

Detect OS and shells. Run the automated
installer to deploy Starship, required
fonts, and bundled CLI tools (zoxide,
fzf, eza, bat) safely without duplicates.

Remind me to select Hack Nerd Font
in my terminal emulator settings.
```

---

## 🧰 Bundled Modern CLI Tools

To deliver a powerful, consistent terminal experience out-of-the-box, the automated setup also installs and configures 4 essential, cross-shell utilities:

| Tool | Role | Description & Integration |
| :--- | :--- | :--- |
| **[`zoxide`](https://github.com/ajeetdsouza/zoxide)** | Smart Jump (`z`) | Ultra-fast directory jumper. Remembers your most frequent paths so you can jump with `z <folder>`. |
| **[`fzf`](https://github.com/junegunn/fzf)** | Fuzzy Finder (`Ctrl+R`) | Interactive fuzzy search across command history, files, and git commits. |
| **[`eza`](https://github.com/eza-community/eza)** | Modern `ls` | Drop-in replacement for `ls` with Nerd Font filetype icons, Git status indicators, and human-readable format. |
| **[`bat`](https://github.com/sharkdp/bat)** | Modern `cat` | Syntax-highlighting file viewer with git modifications gutter integration. |

> [!NOTE]
> **Strict Idempotency Guarantee:** We take the liberty of configuring these utilities across all detected shells (Bash, Zsh, Fish, PowerShell). The configurator **always inspects your shell files first** and skips any tool, plugin (e.g. `jethrokuan/z`, `fzf.fish`), or alias that is already present to prevent duplicate hooks or broken environments.

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
   - **Crucial:** Advise the user to configure **Hack Nerd Font** in their terminal application (e.g. Windows Terminal, Alacritty, Kitty, iTerm2, WezTerm) so all Powerline chevrons, rounded pills, git branch icons, and OS logos render properly.

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

### Step 3: Install Bundled Modern CLI Tools
Install `zoxide`, `fzf`, `eza`, and `bat` if not already installed:
- **Linux / macOS:**
  ```bash
  # zoxide
  command -v zoxide >/dev/null || curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  # eza & bat & fzf (via system package manager if available, or official releases)
  command -v fzf >/dev/null || (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --bin)
  ```
- **Windows (Winget):**
  ```powershell
  winget install -e --id ajeetdsouza.zoxide
  winget install -e --id junegunn.fzf
  winget install -e --id eza-community.eza
  winget install -e --id sharkdp.bat
  ```

### Step 4: Deploy Configuration File
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

### Step 5: Inject Hooks & Aliases into Shell Profiles (Safe & Idempotent)

Verify each tool is not already configured in your target profile before appending:

| Shell | Platform | Target File | Hooks & Aliases to Add (if missing) |
| :--- | :--- | :--- | :--- |
| **Bash** | Linux / WSL / macOS | `~/.bashrc` | `eval "$(starship init bash)"`<br>`eval "$(zoxide init bash)"`<br>`eval "$(fzf --bash)"`<br>`alias ls='eza --icons'`<br>`alias cat='bat -P --style plain'` |
| **Zsh** | Linux / WSL / macOS | `~/.zshrc` | `eval "$(starship init zsh)"`<br>`eval "$(zoxide init zsh)"`<br>`eval "$(fzf --zsh)"`<br>`alias ls='eza --icons'`<br>`alias cat='bat -P --style plain'` |
| **Fish** | Linux / WSL / macOS | `~/.config/fish/config.fish` | `starship init fish \| source`<br>`zoxide init fish \| source` (skip if `z` exists)<br>`fzf --fish \| source` (skip if `fzf.fish` exists)<br>`alias ls="eza --icons"`<br>`alias cat="bat -P --style plain"` |
| **PowerShell** | Windows / Linux / macOS | `$PROFILE` | `Invoke-Expression (&starship init powershell)`<br>`Invoke-Expression (& { (zoxide init powershell \| Out-String) })` |
| **CMD (Clink)** | Windows | `%LOCALAPPDATA%\clink\starship.lua` | `load(io.popen('starship init cmd'):read("*a"))()` |

### Step 6: Install Mandatory Fonts (Hack & FiraCode Nerd Fonts)

A Nerd Font is strictly required to render Powerline symbols (chevrons, rounded pill caps), Git status, and OS logos:
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

### Step 7: Reload Terminal & Apply Font Settings
1. **Reload Shell:** Run `source ~/.bashrc` (or restart PowerShell / CMD).
2. **Set Terminal Font:** Open terminal preferences (Windows Terminal, VS Code, Kitty, Alacritty, iTerm2, WezTerm) and select **Hack Nerd Font** as the font family.

---

## 💬 Visiting Agent Final Checklist

After completing the installation on the client machine, the AI agent should:
1. ✅ Confirm which shells were successfully configured.
2. ✅ Confirm that Starship, bundled CLI tools (zoxide, fzf, eza, bat), and Hack/FiraCode Nerd Fonts are installed.
3. 🔄 Instruct the user to restart their terminal session or source their shell profile.
4. 🔤 Remind the user to select **Hack Nerd Font** in their terminal emulator settings.
5. 💡 If any unsupported environment was encountered, report suggested improvements to the maintainer.
