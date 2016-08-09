#! /bin/bash
DOTFILES_DIR="Dotfiles"
PWD=$(pwd)
for FILE_PATH in $(find $DOTFILES_DIR -mindepth 1 -maxdepth 1)
  do
    FILE=${FILE_PATH#$DOTFILES_DIR/}
    HOME_PATH=$HOME/$FILE
    FULL_PATH=$PWD/$FILE_PATH
    rm -r $HOME_PATH
    ln -s $FULL_PATH $HOME_PATH
done
