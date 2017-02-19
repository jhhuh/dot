#!/bin/sh

script_dir=$(cd $(dirname $0);pwd -P) # Don't worry. $() evaluates the command in a subshell.
home_dir=$HOME

for fn in bashrc bash_profile bash_aliases emacs ghci Xresources tmux.conf vimrc vimrc.vundle
do
    ln -s $script_dir/$fn $home_dir/.$fn
done

git clone https://github.com/VundleVim/Vundle.vim.git $home_dir/.vim/bundle/Vundle.vim 

