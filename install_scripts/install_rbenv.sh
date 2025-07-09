#!/bin/bash

source functions.sh

function latest_ruby_version() {
    # Get the latest stable Ruby version from rbenv
    rbenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | grep -v 'rc' | grep -v 'a' | tail -n 1 | xargs
}

# Verification function for rbenv installation
function verify_install_rbenv() {
    # Check if rbenv is installed
    if ! exists "rbenv"; then
        return 1  # Not completed
    fi
    
    # Check if rbenv is properly initialized
    if ! rbenv versions >/dev/null 2>&1; then
        return 2  # Partially completed - installed but not initialized
    fi
    
    # Check if the specific Ruby version is installed
    local RUBY_VERSION=$(latest_ruby_version)
    if ! rbenv versions | grep -q "$RUBY_VERSION"; then
        return 2  # Not completed - unable to determine latest Ruby version
    fi
    
    # Check if bundler is installed
    if ! gem list bundler | grep -q "bundler"; then
        return 2  # Partially completed - Ruby installed but bundler missing
    fi
    
    return 0  # Fully completed
}

function install_rbenv() {
    startNewSection
    
    if ! verify_install_rbenv; then
        printMessage "Ruby is already installed and verified" "$green"
        return 0
    fi
    
    # Check for Homebrew dependency
    if ! $(exists "brew"); then
        handleError "Homebrew needs to be installed to setup rbenv"
    fi
    
    printMessage "Installing rbenv and Ruby" "$green"
    
    # Install rbenv if not already installed
    if ! $(exists "rbenv"); then
        brew install rbenv ruby-build
    fi
    
    # Initialize rbenv
    eval "$(rbenv init -)"
    
    # Install the latest stable Ruby version using rbenv
    local RUBY_VERSION=$(latest_ruby_version)
    if ! rbenv install "$RUBY_VERSION"; then
        handleError "Failed to install Ruby version $RUBY_VERSION"
    fi
    
    # Set the global Ruby version
    rbenv global "$RUBY_VERSION"
    
    # Install bundler
    gem install bundler
    
    printMessage "Ruby version $RUBY_VERSION installed successfully" "$green"
}
