# VHS tape to record a compact terminal screenshot showing Starship & CLI tools
# Compile: vhs assets/tools_preview.tape

Output "assets/tools_preview.png"
Output "assets/tools_preview.gif"

Set Shell "bash"
Set FontSize 14
Set Width 900
Set Height 280
Set Padding 16
Set FontFamily "Hack Nerd Font"
Set Theme "Catppuccin Mocha"

Hide
Type "export STARSHIP_CONFIG=$PWD/dotfiles/starship.toml" Enter
Type 'eval "$(starship init bash)"' Enter
Type "alias ls='eza --icons'" Enter
Type "clear" Enter
Show

Sleep 500ms
Type "ls -l dotfiles/"
Sleep 300ms
Enter
Sleep 1s

Screenshot "assets/tools_preview.png"
Sleep 1s
