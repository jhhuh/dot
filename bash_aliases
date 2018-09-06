# -*- mode:  sh -*-

alias ccat='pygmentize -g'
alias vi='emacseditor -nw'
alias vij='function __vij() { nix-shell -p pythonPackages.jedi vimHugeX --run "vim $@"; }; __vij'

alias ec="emacseditor -c"
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

# nixos
alias nix-which='function __nix-which() { readlink $(which $1); }; __nix-which'

alias nix-unpack-from='function __nix-unpack-from() { nix-shell $1 -A $2 --run unpackPhase; }; __nix-unpack-from'
alias nix-unpack='nix-unpack-from "<nixpkgs>"'

alias nix-where-from='function __nix-where-from() { nix-build $1 -A $2 --no-out-link; }; __nix-where-from'
alias nix-where='nix-where-from "<nixpkgs>"'

alias nix-show-tree='function __nix-show-tree() { nix-shell -p tree --run "tree $(nix-where $1)"; }; __nix-show-tree'
#alias nix-visit='function __nix-visit() { cd $(nix-where $1); }; __nix-visit'
alias nix-visit='function __nix-visit() { pushd $(nix-where $1); }; __nix-visit'

alias nix-X-help-in-Y='function __nix-X-help-in-Y() { $(nix-where w3m)/bin/w3m $1/share/doc/$2; }; __nix-X-help-in-Y'
alias nix-help='nix-X-help-in-Y $(nix-where nix.doc) nix/manual/index.html'
alias nixpkgs-help='nix-X-help-in-Y $(nix-build --no-out-link "<nixpkgs/doc>") nixpkgs/manual.html'
alias nixos-help='nix-X-help-in-Y $(nix-build "<nixpkgs/nixos/release.nix>" --arg supportedSystems "[ \"x86_64-linux\" ]" -A manual --no-out-link) nixos/index.html'

alias nix-outpath='nix-build --no-out-link "<nixpkgs>" -A'

# yasr aliases
alias yed='$(nix-where yasr)/bin/yasr $(nix-where edbrowse)/bin/edbrowse' 
#alias yasr='speech-dispatcher && yasr -s "speech dispatcher" -p 127.0.0.1:6560' 

# commands in nix-shell
alias nix-python='nix-shell -p python rlwrap --run "rlwrap python"'

# xset
alias xset-rate='xset r rate 330 50'

# load-env
alias freeze-env-ghc80env='nix-instantiate "<nixpkgs>" -k -A ghc80env --indirect --add-root $HOME/ghc80env.drv'
alias load-env-ghc80env='nix-shell $HOME/ghc80env.drv'
