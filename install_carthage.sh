#!/bin/bash

source functions.sh

if exists "carthage"; then
  printMessage "Carthage already installed" $green
  exit 0
fi

if ! $(exists "brew"); then
  printMessage "Homebrew needs to be installed to setup carthage"
  exit 1
fi

if [ ! -d /Applications/Xcode.app ]; then
	printMessage "Xcode needs to be installed to setup carthage"
	exit 1
fi

printMessage "Making sure required Xcode tools are installed"
xcode-select --install

printMessage "Installing Carthage"
brew install carthage
