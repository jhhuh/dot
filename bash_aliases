# -*- mode:  sh -*-

alias pipy-deps='function __pipy-deps() { curl -sL https://pypi.org/pypi/$1/json | jq ".info.requires_dist"; }; __pipy-deps'

alias ccat='pygmentize -g'
alias vi='TMPDIR=/tmp emacseditor -nw'
alias vij='function __vij() { nix-shell -p pythonPackages.jedi vimHugeX --run "vim $@"; }; __vij'

alias l='function _l() { ls --color=always $@|sed -E "s/([a-z0-9]{5,5})[a-z0-9]{27,27}-/[\1]-/"; }; _l'
alias ec="TMPDIR=/tmp emacsclient"
alias ecc="TMPDIR=/tmp emacsclient -c"
alias ee="TMPDIR=/tmp emacseditor -c"

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

alias nix-repl='nix repl "<nixpkgs>"'

alias nix-position='function __nix-position() { nix-instantiate "<nixpkgs>" --eval -A $1.meta.position; }; __nix-position'

alias nix-build--no-out-link='nix-build --no-out-link'

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
