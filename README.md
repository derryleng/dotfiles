# My dotfiles

Software:

- DE/WM(s):
  1. awesome
  2. bspwm, sxhkd, polybar
- Display manager: sddm
- Terminal: alacritty
- Shell: bash, zsh, fish
- App launcher: rofi
- Notifications: dunst
- File browser: thunar
- Web browser: firefox
- Editor: visual-studio-code-bin, neovim

Themes:

- SDDM: https://github.com/GistOfSpirit/TerminalStyleLogin
- Cursor: Bibata-Original-Classic
- Icons: Papirus-Dark
- GTK: Arc-Dark
- Qt: Custom Arc-Dark clone
- VSCode: SolarLiner.linux-themes

Config templates used:

- AwesomeWM: https://github.com/suconakh/awesome-awesome-rc
- Rofi: https://github.com/adi1090x/rofi

## Setup

- Scripted install: https://github.com/derryleng/arch-scripted-install
- Manual install: https://github.com/derryleng/arch-manual-install

## Clone dotfiles

```bash
git clone --bare https://github.com/derryleng/dotfiles.git /home/derry/.dotfiles

# Set dotfiles alias if not done already
# alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```
