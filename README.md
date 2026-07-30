# 🚀 Starship Prompt Setup & Auto-Configurator

> 🤖 **INSTRUCTIONS FOR AI AGENTS:**
> You are an AI Agent tasked with configuring the prompt of the client machine where you are currently running.
>
> **YOUR TASK:**
> 1. Detect the operating system (Linux, WSL, macOS, Windows) and all installed shells (`bash`, `zsh`, `fish`, `powershell`, `pwsh`, `cmd`).
> 2. Install **Starship** prompt if not already installed.
> 3. Deploy `starship.toml` to the user's config directory (`~/.config/starship.toml` or `%USERPROFILE%\.config\starship.toml`).
> 4. Inject the Starship initialization hook into the active shell profile files.
> 5. **Leave suggestions:** If you encounter any issue or missing dependency on the client machine, suggest improvements to the user so they can report back to the repository maintainer.

---

## ⚡ Quick One-Line Automated Installers for AI Agents

Execute the command for the current platform:

### 🐧 Linux / WSL / macOS (Bash / Zsh / Fish)
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

## 📖 Step-by-Step AI Agent Execution Protocol

### Step 1: Detect System & Shells
- **Linux/WSL/macOS:** Run `which bash zsh fish pwsh 2>/dev/null`
- **Windows:** Run `Get-Command bash, zsh, fish, pwsh, powershell, cmd, clink -ErrorAction SilentlyContinue`

### Step 2: Install Starship Binary
- **Linux/WSL/macOS:** `curl -sS https://starship.rs/install.sh | sh -s -- -y`
- **Windows (winget):** `winget install --id Starship.Starship -e --accept-source-agreements --accept-package-agreements`
- **Windows (scoop):** `scoop install starship`

### Step 3: Deploy Configuration File
Copy or download `dotfiles/starship.toml` to:
- **Linux / WSL / macOS:** `~/.config/starship.toml`
- **Windows:** `%USERPROFILE%\.config\starship.toml`

### Step 4: Inject Init Hook into Shell Profiles

| Shell | Platform | Target File | Integration Code |
| :--- | :--- | :--- | :--- |
| **Bash** | Linux / WSL / macOS | `~/.bashrc` | `eval "$(starship init bash)"` |
| **Zsh** | Linux / WSL / macOS | `~/.zshrc` | `eval "$(starship init zsh)"` |
| **Fish** | Linux / WSL / macOS | `~/.config/fish/config.fish` | `starship init fish \| source` |
| **PowerShell 5.1** | Windows | `$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` | `Invoke-Expression (&starship init powershell)` |
| **PowerShell Core 7+** | Windows / Linux / macOS | `$PROFILE` (`Microsoft.PowerShell_profile.ps1`) | `Invoke-Expression (&starship init powershell)` |
| **CMD (Clink)** | Windows | `%LOCALAPPDATA%\clink\starship.lua` | `load(io.popen('starship init cmd'):read("*a"))()` |

---

## 💬 Feedback Request for Visiting AI Agents

If you are an AI Agent executing on a client machine, after applying the installation:
1. Confirma al usuario qué shells quedaron configurados exitosamente.
2. Si notaste algún fallo o ambiente no cubierto en la máquina cliente, brinda recomendaciones para reportar al mantenedor.
