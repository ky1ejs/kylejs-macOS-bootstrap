#! /bin/bash

info 'installing dotfiles'

for dotfile in $(find -H Dotfiles -mindepth 1 -maxdepth 1)
do
    ln -s "$dotfile" "$HOME/$src"
done
