#!/bin/sh -x

BREW_URL="https://raw.github.com/mxcl/homebrew/go/install"
if [ ! -x "/usr/local/bin/brew" ]; then
    curl -fsSL "${BREW_URL}" > brew_install.rb
    ruby ./brew_install.rb
fi
