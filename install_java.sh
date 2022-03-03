#!/bin/bash

source functions.sh

if ! $(exists "brew"); then
  printMessage "Homebrew needs to be installed to setup fish"
  exit 1
fi

if ! $(exists "jenv"); then
  printMessage "Please install jenv fist"
  exit 1
fi


printMessage "Installing Java 11 for M1"
brew tap homebrew/cask-versions
brew install --cask zulu11
jenv add $(/usr/libexec/java_home)
jenv global 11.0

printMessage "Java 11 for M1 installed"
