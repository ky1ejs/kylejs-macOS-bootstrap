#!/bin/sh -x

BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
if [ ! -x "/usr/local/bin/brew" ]; then
    curl -fsSL "${BREW_URL}" > brew_install.rb
    ruby ./brew_install.rb
fi
