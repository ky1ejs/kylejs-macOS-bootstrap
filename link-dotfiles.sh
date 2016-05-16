#! /bin/bash

echo 'installing dotfiles'

for dotfile in $(find -H Dotfiles -mindepth 1 -maxdepth 1)
do
    ln -s "$dotfile" "$HOME/$dotfile"
done

ln -s $(pwd)/bin $HOME/bin
