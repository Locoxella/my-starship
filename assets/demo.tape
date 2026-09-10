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
Type "clear" Enter
Show

Sleep 800ms
Type "fastfetch --structure Title:OS:Host:Kernel:Shell:Terminal"
Sleep 500ms
Enter
Sleep 2s

Type "eza --icons --group-directories-first dotfiles/"
Sleep 500ms
Enter
Sleep 2s

Type "echo 'Cross-shell prompt powered by Starship! 🚀'"
Sleep 500ms
Enter
Sleep 3s
