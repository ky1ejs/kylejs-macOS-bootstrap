#!/bin/bash

source functions.sh

BREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

function brewFilePath() {
  # check MACHINE_TYPE environment variable to determine the Brewfile path
  if [[ "$MACHINE_TYPE" == "work" ]]; then
    echo "Brewfile.work"
  else
    echo "Brewfile.personal"
  fi
}

# Verification function for Homebrew installation
function verify_install_brew() {
    # update the PATH to include Homebrew
    export PATH="/opt/homebrew/bin:$PATH"

    # Check if Homebrew is installed
    if ! exists "brew"; then
      return 1  # Not completed
    fi

    # Run brew bundle check on the common Brewfile
    if ! brew bundle check --file="Brewfile" >/dev/null 2>&1; then
      printMessage "Brewfile is partially installed or needs updating" "$yellow"
     fi

    
    local BREWFILE=$(brewFilePath)
    # Use brew bundle check to see if packages are installed
    if ! brew bundle check --file="$BREWFILE" >/dev/null 2>&1; then
      printMessage "Brewfile for $MACHINE_TYPE is partially installed or needs updating" "$yellow"
    fi
        
    return 0  # Fully completed
}

function install_brew() {
  if verify_install_brew; then
    printMessage "Homebrew is already installed and verified" "$green"
    exit 0
  fi

  # update the PATH to include Homebrew if it doesn't include
  if [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
  fi

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
  
  # Install common Brewfile
  printMessage "Installing common Brewfile" "$green"
  if brew bundle --file="Brewfile"; then
    printMessage "Common Brewfile installed successfully" "$green"
  else
    handleError "Some failures in installing common Brewfile" "$red"
  fi

  # Install packages from Brewfile
  local BREWFILE=$(brewFilePath)
  printMessage "Installing packages and apps from Brewfile" "$green"
  if brew bundle --file="$BREWFILE"; then
    printMessage "$BREWFILE packages installed successfully" "$green"
  else
    handleError "Some failures in installing packages for $BREWFILE" "$red"
  fi
}
