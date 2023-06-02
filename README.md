# My dotfiles


## Arch Install Instructions

Manual install: https://github.com/derryleng/arch-manual-install

Or just use [archinstall](https://wiki.archlinux.org/title/archinstall) lol.

## Clone dotfiles

```bash
git clone --bare https://github.com/derryleng/dotfiles.git /home/derry/.dotfiles

# Set dotfiles alias if not done already
# alias dotfiles='/usr/bin/git --git-dir=/home/derry/.dotfiles/ --work-tree=/home/derry'

dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```

## Resources

Config templates used:

- AwesomeWM: https://github.com/suconakh/awesome-awesome-rc
- Rofi: https://github.com/adi1090x/rofi

Themes used:

- SDDM theme: https://github.com/GistOfSpirit/TerminalStyleLogin
