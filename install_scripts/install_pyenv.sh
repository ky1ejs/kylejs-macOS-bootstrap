#! /bin/bash

source functions.sh

function latest_stable_python_version() {
  # Get the latest stable Python version from pyenv
  pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | grep -v 'rc' | grep -v 'a' | tail -n 1 | xargs
}


function verify_install_pyenv() {
  if ! exists "pyenv"; then
    return 2  # Not completed
  fi
  
  local latest_version=$(latest_stable_python_version)
  if ! pyenv versions | grep -q "$latest_version"; then
    return 1  # Partially completed - pyenv installed but latest Python version not configured
  fi

  echo "Python is installed"
  
  return 0  # Fully completed
}

function install_pyenv() {
  startNewSection
  if verify_install_python; then
    printMessage "Python is already installed and verified" "$green"
    exit 0
  fi
  
  # Check for Homebrew dependency
  if ! $(exists "brew"); then
    handleError "Homebrew needs to be installed to setup Python"
  fi
  
  printMessage "Installing Python using pyenv" "$green"
  
  # Install pyenv if not already installed
  if ! $(exists "pyenv"); then
    brew install pyenv
  fi
  
  # Install the latest stable Python version using pyenv
  local python_version=$(latest_stable_python_version)
  if ! pyenv install "$python_version"; then
    handleError "Failed to install Python version $python_version"
  fi

  # make latest version the global default
  if ! pyenv global "$python_version"; then
    handleError "Failed to set Python version $python_version as global default"
  fi
  
  printMessage "Python version $python_version installed successfully" "$green"
} 