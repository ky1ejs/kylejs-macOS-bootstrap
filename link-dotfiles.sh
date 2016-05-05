#! bin/bash

info 'installing dotfiles'

for src in $(find -H Dotfiles -maxdepth 0)
do
    ln "$src" "$HOME/$src"
done
