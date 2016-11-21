#alias ec="emacsclient -a '' -c "
#alias et="emacsclient -a '' -t "
#alias emacs="emacs -nw"
#alias qemu="qemu-system-x86_64"

#alias root="LD_LIBRARY_PATH=/usr/local/lib/root root -l"
alias dossh='mosh 45.55.202.188'
alias dossh2='mosh 188.166.82.217'
alias dossh2deluge='ssh -L 8112:localhost:8112 188.166.82.217'
alias dossh2remote='ssh -R 2222:localhost:22 188.166.82.217'
alias atl='ssh atlantis.snu.ac.kr'

alias afind='apt-cache search '

# tmux aliases
alias ta='tmux -2 attach'
alias tls='tmux -2 ls'
alias tat='tmux -2 attach -t'
alias tns='tmux -2 new-session -s'

# nix-shell assisted
with-jedi() {
    nix-shell -p pythonPackages.jedi --run '$@'
}
alias vim-jedi='with-jedi vim '
