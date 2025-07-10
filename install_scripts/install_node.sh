source functions.sh

function latest_node_version() {
  # Get the latest stable version of Node.js
  fnm ls-remote --lts | tail -n 1 | awk '{print $1}'
}

function verify_install_node() {
  # Check if fnm is installed
  if ! exists "fnm"; then
    return 1  # Not completed
  fi

  # figure out what latest stable version of Node.js is
  local node_version=$(latest_node_version)
  if ! fnm list | grep -q "$node_version"; then
    return 2  # Partially completed - fnm installed but latest Node.js not configured
  fi
}

function install_node() {
  startNewSection
  if verify_install_node; then
    printMessage "Node.js is already installed and verified" "$green"
    exit 0
  fi

  # Check for Homebrew dependency
  if ! $(exists "brew"); then
    handleError "Homebrew needs to be installed to setup Node.js"
  fi

  printMessage "Installing Node.js using fnm" "$green"

  # Install fnm if not already installed
  if ! $(exists "fnm"); then
    brew install fnm
  fi

  # Install Node.js version 22 using fnm
  local node_version=$(latest_node_version)
  if ! fnm install "$node_version"; then
    handleError "Failed to install Node.js version $node_version"
  fi

  # Install pnpm
  if ! $(exists "pnpm"); then
    printMessage "Installing pnpm package manager" "$green"
    corepack enable pnpm
  fi

  printMessage "Node.js version $node_version installed successfully" "$green"
}
  
    