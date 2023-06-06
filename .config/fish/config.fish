if status is-interactive
    # Commands to run in interactive sessions can go here
    neofetch | lolcat -p 10 -F 0.3 && fortune
    # neofetch --ascii "$(fortune | cowsay -f tux -W 50)"
end

# Empty git repo for tracking dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotdiff='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME diff'
alias dotdiffnames='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME diff --name-only'
alias dotdiffc='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME diff --cached'
alias dotdiffcnames='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME diff --cached --name-only'
alias dotadd='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME add -u'
alias dotcommit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -m'
alias dotpush='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME push origin main'

set -U fish_greeting ""
