#!/bin/sh

brew install rbenv
RUBY_VERSION="2.3.1"
eval "$(rbenv init -)"
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
rbenv rehash
~/.rbenv/shims/gem install bundle
rbenv rehash
~/.rbenv/shims/bundle install
