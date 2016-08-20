#!/bin/sh

script_dir=$(dirname "$(readlink -f "$0")")
home_dir=$HOME

for fn in bash_aliases bashrc emacs ghci tmux.conf vimrc vimrc.vundle
do
    ln -s $script_dir/$fn $home_dir/.$fn
done
