# VHS tape to record a compact terminal animation showing Starship & CLI tools
# Compile: vhs assets/tools_preview.tape

Output "assets/tools_preview.gif"
Output "assets/tools_preview.png"

Set Shell "bash"
Set FontSize 14
Set Width 900
Set Height 340
Set Padding 16
Set FontFamily "Hack Nerd Font"
Set Theme "Catppuccin Mocha"

Hide
Type "export STARSHIP_CONFIG=$PWD/dotfiles/starship.toml" Enter
Type 'eval "$(starship init bash)"' Enter
Type "alias ls='eza --icons'" Enter
Type "clear" Enter
Show

Sleep 400ms
Type "ls -l dotfiles/"
Sleep 300ms
Enter
Sleep 1.5s

Type "cat dotfiles/starship.toml | head -n 4"
Sleep 300ms
Enter
Sleep 2s

Screenshot "assets/tools_preview.png"
Sleep 2.5s
