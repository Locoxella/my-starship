# VHS tape to record an animated demo GIF for my-starship
# Installation: https://github.com/charmbracelet/vhs
# Compile: vhs assets/demo.tape

Output assets/demo.gif

Set Shell "bash"
Set FontSize 14
Set Width 960
Set Height 650
Set Padding 20
Set FontFamily "Hack Nerd Font"
Set Theme "Catppuccin Mocha"

# Setup custom Starship prompt inside recording session
Hide
Type "export STARSHIP_CONFIG=$PWD/dotfiles/starship.toml" Enter
Type 'eval "$(starship init bash)"' Enter
Type 'eval "$(zoxide init bash)"' Enter
Type "alias ll='eza -l -g --icons'" Enter
Type "alias cat='bat -P --style plain'" Enter
Type "mkdir -p /tmp/cloud-native-microservice && zoxide add /tmp/cloud-native-microservice && cd $PWD" Enter
Type "printf '\033[2J\033[H'" Enter
Show

Sleep 600ms
Type "fastfetch --structure Title:OS:Kernel:Shell"
Sleep 400ms
Enter
Sleep 2s

Type "ll dotfiles/"
Sleep 400ms
Enter
Sleep 2s

Type "z cloud-native"
Sleep 400ms
Enter
Sleep 2s

Type "git init -b feature/rocket-launch"
Sleep 400ms
Enter
Sleep 1.5s

Type "touch deploy.yaml"
Sleep 400ms
Enter
Sleep 1.5s

Type "cat /repo/README.md 2>/dev/null || cat README.md | head -n 12"
Sleep 400ms
Enter
Sleep 3s
