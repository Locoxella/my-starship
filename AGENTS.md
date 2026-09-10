# 🤖 AGENTS.md — Repository Maintainer & Agent Instructions

This document provides instructions, architecture guidelines, and operational workflows for AI coding assistants (Antigravity, Cursor, Windsurf, Claude Code, Copilot, etc.) **maintaining or modifying this repository**.

---

## 🎯 Separation of Concerns (Critical Rule)

* **[`README.md`](README.md):** Strictly intended for **end users** and **visiting AI agents** executing on client machines to install Starship. It must only contain user-facing installation instructions, 1-click deployment prompts, shell hooks, and font setup.
* **[`AGENTS.md`](AGENTS.md) & [`docs/`](docs/):** Dedicated to the **repository maintainer** and development agents working on the codebase itself. Internal maintenance scripts, VHS recordings, local sync tools, and system logs belong here.

---

## 🏗️ Repository Structure

```text
my-starship/
├── .github/workflows/         # CI automation
│   ├── test-distros.yml       # Multi-distro container verification matrix
│   └── validate.yml           # Syntax & TOML config validator
├── assets/                    # Visual presentation assets
│   ├── demo.gif               # Animated VHS recording
│   ├── demo.tape              # VHS declarative script for recording demo GIFs
│   └── prompt_preview.svg     # Pre-rendered vector mockup of the prompt
├── dotfiles/                  # Publicly deployed artifacts (Single Source of Truth)
│   ├── install_nerd_font.sh   # Automated Hack & FiraCode NF installer
│   ├── setup_starship.ps1     # Windows PowerShell auto-configurator
│   ├── setup_starship.sh      # Linux/macOS/WSL auto-configurator
│   ├── setup_starship_cmd.bat # Windows Command Prompt (Clink) installer
│   └── starship.toml          # Master Starship prompt configuration
├── docs/                      # Internal maintenance logs & records
│   └── fedora_maintenance.md  # Fedora (Scar laptop) hardware/OS maintenance logs
├── scripts/                   # Local maintainer scripts (ignored / internal)
│   ├── maintenance/           # Host-specific maintenance scripts (e.g. remove_snap.sh)
│   └── sync_starship_local.sh # Synchronizes ~/.config/starship.toml -> dotfiles/
├── tests/                     # CI test suite & container bootstrap
│   ├── bootstrap_distro.sh    # Prepares container environments (Fedora, Ubuntu, etc.)
│   └── verify_installation.sh # Automated test suite (binaries, fonts, idempotence)
├── AGENTS.md                  # This file (AI maintainer instructions)
└── README.md                  # Client & visiting-agent documentation
```

---

## 🔄 Maintainer Workflows

### 1. Synchronizing Local Prompt Changes (Node: Scar)
The host computer (`Scar`) serves as the master environment:
1. When adjusting `~/.config/starship.toml` locally, sync and validate it into the repo:
   ```bash
   ./scripts/sync_starship_local.sh
   ```
2. This script validates syntax via `starship print-config` and copies the file to `dotfiles/starship.toml`.

### 2. Generating Animated Demo GIFs (VHS)
To update the animated demo GIF using [VHS](https://github.com/charmbracelet/vhs):
```bash
vhs assets/demo.tape
```
*Note: The generated GIF can be placed in `assets/demo.gif` if needed.*

### 3. Pre-Commit Validation Checks
Always ensure all scripts pass syntax checks and the TOML config is valid before pushing:
```bash
# Validate Starship configuration
STARSHIP_CONFIG=dotfiles/starship.toml starship print-config > /dev/null

# Validate Shell scripts syntax
bash -n dotfiles/setup_starship.sh
bash -n dotfiles/install_nerd_font.sh
bash -n scripts/sync_starship_local.sh
bash -n scripts/maintenance/remove_snap.sh
bash -n tests/verify_installation.sh
bash -n tests/bootstrap_distro.sh

# Run local installation test suite
./tests/verify_installation.sh
```

---

## 🛡️ Coding Guidelines for Agents
1. **Keep Public URLs Intact:** Client scripts in `dotfiles/` must continue to work when fetched via `curl -fsSL https://raw.githubusercontent.com/Locoxella/my-starship/main/dotfiles/...`
2. **Idempotence:** Every setup script must be safe to run multiple times without duplicating shell hooks or corrupting profile files.
3. **Multi-Platform Support:** When altering `starship.toml` or setup scripts, ensure compatibility across Linux, WSL, macOS, Windows PowerShell, and CMD.
4. **Font Standards:** Always use **Hack Nerd Font** for terminal/console tasks and **FiraCode Nerd Font** for code editors/IDEs. Never use or assume JetBrains Mono.
