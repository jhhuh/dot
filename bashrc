# Just in case /usr/local/bin is not included
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if [ -f ~/.nix-profile/share/git/contrib/completion/git-completion.bash ]; then
    source ~/.nix-profile/share/git/contrib/completion/git-completion.bash
elif [ -f $(readlink `which git`|xargs dirname)/../share/git/contrib/completion/git-completion.bash ]; then
    source $(readlink `which git`|xargs dirname)/../share/git/contrib/completion/git-completion.bash
fi

# bash colors
export LS_OPTIONS="--color=auto"; eval "`dircolors`"
#(ls --color=auto &> /dev/null \
#    && ( export LS_OPTIONS="--color=auto"; eval "`dircolors`" ))\
#|| export LS_OPTIONS="-G"
alias ls="ls $LS_OPTIONS" 

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs

# prevent sudden exit
set -o ignoreeof

# git-prompt
if [ -f ~/.nix-profile/share/git/contrib/completion/git-prompt.sh ]; then
    source ~/.nix-profile/share/git/contrib/completion/git-prompt.sh
elif [ -f $(readlink `which git`|xargs dirname)/../share/git/contrib/completion/git-prompt.sh ]; then
    source $(readlink `which git`|xargs dirname)/../share/git/contrib/completion/git-prompt.sh
fi

get_sha() {
    git rev-parse --short HEAD 2>/dev/null
}

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"
PROMPT_COLOR="1;31m"
let $UID && PROMPT_COLOR="1;32m"
#PS1='\n\[\033[$PROMPT_COLOR\][\u@\h \W]\[\033[0m\]$(__git_ps1 " (%s)")\n\$ '
PROMPT_COMMAND='__git_ps1 "'
PROMPT_COMMAND+='\[\033[00;36m\]\u\[\033[00m\]@'
PROMPT_COMMAND+='\[\033[00;32m\]\h\[\033[00m\]:'
PROMPT_COMMAND+='\[\033[00;34m\]\w\[\033[00m\]'
PROMPT_COMMAND+='" "'
PROMPT_COMMAND+='\n'
PROMPT_COMMAND+='\[\033[01;35m\]$(is_in_nixshell "(" ")")\[\033[00m\]$ '
PROMPT_COMMAND+='" "(%s)"'

is_in_nixshell() {
    if [ $IN_NIX_SHELL ]
    then
        echo "$1$name$2"
    fi
}

# fix for broken characters
export TERM=screen

# my little secret
if [ -r ~/.not-public ]; then
    source ~/.not-public
fi

# cabal 
export PATH=~/.cabal/bin:"$PATH"

# TMPDIR
#export TMPDIR=~/.tmp

# PERL5
#PATH="/Users/jhhuh/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="/Users/jhhuh/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="/Users/jhhuh/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"/Users/jhhuh/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/Users/jhhuh/perl5"; export PERL_MM_OPT;

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

# completion with sudo
complete -cf sudo

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

if [ -f ~/.profile ]; then
    source ~/.profile
fi

export DTK_PROGRAM=espeak

export SYSTEMD_LESS=FRXMK

