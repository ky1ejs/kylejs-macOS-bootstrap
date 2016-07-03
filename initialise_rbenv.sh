#!/bin/sh

RUBY_VERSION="2.3.1"

brew install rbenv
rbenv init
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
rbenv rehash
~/.rbenv/shims/gem install bundle
rbenv rehash
ls -la ~/.rbenv/shims/
~/.rbenv/shims/bundle install
