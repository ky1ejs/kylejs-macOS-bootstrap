#!/bin/bash

source functions.sh

# Verification function for Fish shell installation
function verify_install_fish() {
    # Check if Fish is installed
    if ! exists "fish"; then
        return 1  # Not completed
    fi
    
    # Check if Fish is in /etc/shells (optional but recommended)
    if ! grep -q "$(which fish)" /etc/shells 2>/dev/null; then
        return 2  # Partially completed - installed but not in shells
    fi
    
    return 0  # Fully completed
}

function install_fish() {
  startNewSection
  
  # Verify if Fish shell is already installed
  if verify_install_fish; then
    printMessage "Fish shell is already installed and verified" "$green"
    return 0
  fi

  # Check for Homebrew dependency
  if ! $(exists "brew"); then
    handleError "Homebrew needs to be installed to setup fish"
  fi

  # Check if Fish is already installed
  printMessage "Installing Fish shell" "$green"  
  if brew install fish; then
    printMessage "Fish shell installed successfully" "$green"
    
    # Provide setup instructions
    printMessage "Fish shell setup instructions:" "$green"
    printMessage "To set Fish as default shell:" "$reset"
    printMessage "1. Add Fish to shells: sudo echo $(which fish) >> /etc/shells" "$reset"
    printMessage "2. Change shell: chsh -s $(which fish)" "$reset"
    printMessage "3. For theming, consider installing Oh My Fish or similar" "$reset"
    
  else
    handleError "Failed to install Fish shell"
  fi
}