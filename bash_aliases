alias vi='vim'
alias vij='function __vij() { nix-shell -p pythonPackages.jedi vimHugeX --run "vim $@"; }; __vij'

alias ec="emacsclient"
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

# stack aliases
alias ghci-stack='stack ghci'

# yasr aliases
alias yed='yasr `which edbrowse`' 

# nixos
alias nix-unpack-from='function __nix-unpack-from() { nix-shell $1 -A $2 --run unpackPhase; }; __nix-unpack-from'
alias nix-unpack='nix-unpack-from "<nixpkgs>"'
alias nix-where='function __nix-where() { readlink $(which $1); }; __nix-where'
alias nix-show-tree='function __nix-show-tree() { tree $(dirname $(nix-where $1)); }; __nix-show-tree'
