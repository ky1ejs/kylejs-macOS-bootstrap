#!/bin/bash

source functions.sh

if [ ! -d /Applications/Xcode.app ]; then
	printMessage "Please start by installing Xcode and its command line tools by opening it"
	exit 0
fi

./install_brew.sh
./configure_defaults.sh
./link_dotfiles.sh
./install_fish.sh
./install_rbenv.sh
./link_xcode_theme.sh
