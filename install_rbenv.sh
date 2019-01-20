#!/bin/bash

RUBY_VERSION="2.6.0"

source functions.sh

if ! $(exists "brew"); then
  printMessage "Homebrew needs to be installed to setup rbenv"
  exit 1
fi

printMessage "Installing rbenv"
brew install rbenv

printMessage "Installing Ruby version ${RUBY_VERSION}"
rbenv init
rbenv install $RUBY_VERSION
rbenv rehash
rbenv global $RUBY_VERSION

export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH" 

printMessage "Installing bundler"
gem install bundler
rbenv rehash
