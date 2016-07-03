#!/bin/sh

RUBY_VERSION="2.3.1"

brew install rbenv
rbenv init

rbenv install $RUBY_VERSION
rbenv rehash
rbenv global $RUBY_VERSION

PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"

gem install bundler
rbenv rehash

ls -la ~/.rbenv/shims/
rbenv versions
which ruby
which bundle

~/.rbenv/shims/bundle install
