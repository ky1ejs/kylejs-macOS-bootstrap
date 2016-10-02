#!/bin/bash

source functions.sh

if ! $(exists "brew"); then
  printMessage "Homebrew needs to be installed to setup provisioning profile quick look"
  exit 1
fi

printMessage "Setting up quick look for provisioning profiles"
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
killall Finder
