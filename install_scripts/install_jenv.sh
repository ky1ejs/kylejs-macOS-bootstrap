#!/bin/bash

source functions.sh

function check_jenv_for_latest_version() {
  # Check if the latest version is already added to jenv
  if jenv versions | grep -q "21.0"; then
    return 0  # Latest version already added
  fi
  
  return 1  # Latest version not added
}

# Verification function for jenv installation
function verify_install_jenv() {
  # Check if jenv is installed
  if ! exists "jenv"; then
    return 1  # Not completed
  fi
  
  # Check if jenv is properly initialized
  if ! jenv versions >/dev/null 2>&1; then
    return 2  # Partially completed - installed but not initialized
  fi

  # Check if Java 21 is installed and configured
  if ! check_jenv_for_latest_version; then
    return 2  # Partially completed - jenv works but latest Java version not configured
  fi
  
  return 0  # Fully completed
}

function install_jenv() {
  startNewSection
  if verify_install_jenv; then
      printMessage "Java is already installed and verified" "$green"
      exit 0
  fi

  # Check for Homebrew dependency
  if ! $(exists "brew"); then
      handleError "Homebrew needs to be installed to setup jenv"
  fi

  # Install jenv if not already installed
  if ! $(exists "jenv"); then
      printMessage "Installing jenv" "$green"
      brew install jenv
  fi

  # Initialize jenv
  eval "$(jenv init -)"

  # Enforce install if work machine
  if [[ "$MACHINE_TYPE" == "work" ]]; then
    printMessage "Installing Java 21 for work machine" "$green"
    while ! check_jenv_for_latest_version; do
      echo -e '\n'
      echo "------------"
      echo "Latest Java version not added to jenv."
      echo "Please add it manually by downloading the latest Java version from:"
      echo "https://downloads.corretto.aws/#/downloads"
      echo "After downloading, run the following command to add it to jenv:"
      echo "jenv add \$(/usr/libexec/java_home -v 21.0)"
      echo "Then run 'jenv global 21.0' to set it as the global version."
      echo "Press Enter to continue after adding the latest Java version to jenv."
      read -r
      if ! check_jenv_for_latest_version; then
        echo "Java 21 added to jenv successfully."
        jenv global 21.0
        break
      fi
    done
  else 
    printMessage "Install a Java version when you're ready." "$green"
  fi
}
