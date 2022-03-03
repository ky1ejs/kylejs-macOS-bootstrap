#!/bin/bash

source functions.sh

if ! $(exists "brew"); then
  printMessage "Homebrew needs to be installed to setup fish"
  exit 1
fi

printMessage "Installing fish"
brew install fish

curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish

printMessage "fish installed\n\nTo set as default, run:\n\n\$ sudo echo /usr/local/bin/fish >> /etc/shells
\n\$ chsh -s `which fish`\n\nFor theming run\n\n\$"
