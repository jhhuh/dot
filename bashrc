# $HOME/.local/bin /usr/local/bin 
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

# Alias definitions.
if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

# cabal 
export PATH=~/.cabal/bin:"$PATH"

# brew bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi 

# bash colors
(ls --color=auto &> /dev/null \
    && ( export LS_OPTIONS="--color=auto"; eval "`dircolors`" ))\
|| export LS_OPTIONS="-G"
alias ls="ls $LS_OPTIONS" 

# prevent sudden exit
set -o ignoreeof

# git-prompt
get_sha() {
    git rev-parse --short HEAD 2>/dev/null
}
#export GIT_PS1_SHOWCOLORHINTS=1
#if [ -f "$(brew --prefix git)/etc/bash_completion.d/git-prompt" ]; then
#    source "$(brew --prefix git)/etc/bash_completion.d/git-prompt" >/dev/null
#fi
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"
PROMPT_COMMAND='__git_ps1 "\033[01;33m\]$(is_in_nixshell)\033[00m\]\[\033[01;32m\]|\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]|\033[01;33m\]$CONDA_DEFAULT_ENV\033[00m\]|" "\n$ " "[%s $(get_sha)]"'

is_in_nixshell() {
    if [ $IN_NIX_SHELL ]
    then
        echo $nativeBuildInputs |sed -ne 's#.*\(/nix/store/[a-z0-9]\{32\}-\)\(.*\)#\*NIX\* \2 #p'
    fi
}

# my little secret
if [ -r ~/.not-public ]; then
    source ~/.not-public
fi

# PERL5
PATH="/Users/jhhuh/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/jhhuh/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/jhhuh/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/jhhuh/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/jhhuh/perl5"; export PERL_MM_OPT;

# colored man
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
}

# Some nix functions
fnix() {
    nix-env -qasP --description ".*${1}.*"
}
dnix() {
    nix-store --query --references $(nix-instantiate '<nixpkgs>' -A $1)
}

# nvm ! moved to .sandboxrc
#export NVM_DIR="$HOME/.nvm"
#source "$(brew --prefix nvm)/nvm.sh"

# sandboxd: see https://github.com/benvan/sandboxd (modified)
source $HOME/.sandboxd

