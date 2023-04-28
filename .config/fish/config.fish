if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Empty git repo for tracking dotfiles
alias dotfiles='/usr/bin/git --git-dir=/home/derry/.dotfiles/ --work-tree=/home/derry'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/derry/anaconda3/bin/conda
    eval /home/derry/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<