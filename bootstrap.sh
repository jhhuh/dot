#!/bin/sh

script_dir=$(dirname "$(readlink -f "$0")")
home_dir=$HOME

for fn in bashrc bash_profile bash_aliases emacs ghci tmux.conf vimrc vimrc.vundle
do
    ln -s $script_dir/$fn $home_dir/.$fn
done
