# VHS tape to record an animated demo GIF for my-starship
# Installation: https://github.com/charmbracelet/vhs
# Compile: vhs assets/demo.tape

Output assets/demo.gif

Set Shell "bash"
Set FontSize 16
Set Width 960
Set Height 420
Set Padding 20
Set FontFamily "JetBrainsMono Nerd Font"
Set Theme "Catppuccin Mocha"

# Setup custom Starship prompt inside recording session
Hide
Type "export STARSHIP_CONFIG=$PWD/dotfiles/starship.toml" Enter
Type 'eval "$(starship init bash)"' Enter
Type "clear" Enter
Show

Sleep 1s
Type "cd ~/repos/my-starship"
Sleep 600ms
Enter
Sleep 1.2s

Type "git status"
Sleep 600ms
Enter
Sleep 2s

Type "echo 'Cross-shell prompt powered by Starship! 🚀'"
Sleep 600ms
Enter
Sleep 3s
