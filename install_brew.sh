#!/bin/bash

source functions.sh

BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"

if [ ! -d /Applications/Xcode.app ]; then
	printMessage "Xcode needs to be installed to setup homebrew"
	exit 1
fi

if ! $(exists "brew"); then
	printMessage "Installing Homebrew"
	/usr/bin/ruby -e "$(curl -fsSL ${BREW_URL})"
	printMessage "Running 'brew bundle'"
	brew update
	brew tap Homebrew/bundle
	brew bundle
else
  printMessage "Homebrew is already installed\n\n${red}'brew bundle' not invoked"
fi
