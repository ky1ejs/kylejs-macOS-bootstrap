#!/bin/bash

source functions.sh

BREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# Verification function for Homebrew installation
function verify_install_brew() {
    # Check if Homebrew is installed
    if ! exists "brew"; then
        return 1  # Not completed
    fi
    
    # Check if Brewfile packages are installed
    if [ -f "Brewfile" ]; then
        # Use brew bundle check to see if packages are installed
        if ! brew bundle check --file=Brewfile >/dev/null 2>&1; then
            return 2  # Partially completed - brew installed but packages missing
        fi
    fi
    
    return 0  # Fully completed
}

function install_brew() {
  if verify_install_brew; then
    printMessage "Homebrew is already installed and verified" "$green"
    exit 0
  fi

  # update the PATH to include Homebrew
  export PATH="/opt/homebrew/bin:$PATH"

  # Check for Xcode dependency
  if [ ! -d /Applications/Xcode.app ]; then
    handleError "Xcode needs to be installed to setup homebrew"
  fi
  
  if /bin/bash -c "$(curl -fsSL ${BREW_URL})"; then
    printMessage "Homebrew installed successfully" "$green"
  else
    handleError "Failed to install Homebrew"
  fi
  
  # Update Homebrew
  printMessage "Updating Homebrew" "$green"
  if brew update; then
    printMessage "Homebrew updated successfully" "$green"
  else
    printMessage "Warning: Homebrew update failed" "$red"
  fi
  
  # Install packages from Brewfile
  printMessage "Installing packages and apps from Brewfile" "$green"
  if brew bundle; then
    printMessage "Brew packages installed successfully" "$green"
  else
    handleError "Failed to install packages from Brewfile"
  fi
}
