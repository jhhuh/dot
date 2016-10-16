#!/bin/sh

script_dir=$(cd $(dirname $0);pwd -P) # Don't worry. $() evaluates the command in a subshell.
home_dir=$HOME

echo "script_dir = $script_dir"
echo "home_dir = $home_dir"

for fn in bash_aliases bashrc emacs ghci tmux.conf vimrc vimrc.vundle sandboxd sandboxrc
do
    ln -s $script_dir/$fn $home_dir/.$fn 2>/dev/null \
        && echo ".$fn is linked." \
        || echo ".$fn already exists. (skip)"
done
