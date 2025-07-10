#!/bin/bash

# ASCII art banner for "kylejs macOS bootstrap"
echo ""
echo "██   ██ ██    ██ ██      ███████      ██ ███████"
echo "██  ██   ██  ██  ██      ██           ██ ██     "
echo "█████     ████   ██      █████        ██ ███████"
echo "██  ██     ██    ██      ██      ██   ██      ██"
echo "██   ██    ██    ███████ ███████  █████  ███████"
echo ""
echo "                                               "
echo "███    ███  █████   ██████  ██████  ███████    "
echo "████  ████ ██   ██ ██      ██    ██ ██         "
echo "██ ████ ██ ███████ ██      ██    ██ ███████    "
echo "██  ██  ██ ██   ██ ██      ██    ██      ██    "
echo "██      ██ ██   ██  ██████  ██████  ███████    "
echo ""
echo "                                               "
echo "██████   ██████   ██████  ████████ ███████ ████████ ██████   █████  ██████  "
echo "██   ██ ██    ██ ██    ██    ██    ██         ██    ██   ██ ██   ██ ██   ██ "
echo "██████  ██    ██ ██    ██    ██    ███████    ██    ██████  ███████ ██████  "
echo "██   ██ ██    ██ ██    ██    ██         ██    ██    ██   ██ ██   ██ ██      "
echo "██████   ██████   ██████     ██    ███████    ██    ██   ██ ██   ██ ██      "
echo ""

source functions.sh
source install_scripts/install_brew.sh
source install_scripts/install_node.sh
source install_scripts/install_python.sh
source install_scripts/install_rbenv.sh
source install_scripts/link_dotfiles.sh
source install_scripts/configure_defaults.sh
source install_scripts/link_xcode_theme.sh
source install_scripts/install_jenv.sh
source install_scripts/install_fish.sh

# Generic function to handle install verification and execution
handle_install() {
  local verify_function="$1"
  local install_function="$2"
  local action_message="$3"
  local completion_message="$4"
  local error_suffix="$5"
  
  if ! $verify_function; then
    echo "$action_message"
    if ! $install_function; then
      echo "Failed to $action_message $error_suffix"
      exit 1
    fi
  fi
  
  if [ -n "$completion_message" ]; then
    echo "$completion_message"
  fi
}

# Process dotfiles linking first (before app installations)
handle_install "verify_link_dotfiles" "link_dotfiles" "Linking dotfiles..." "Dotfiles linked..." "Please check the Dotfiles directory and try again."

# Function to wait for app installation
wait_for_app() {
  local app_path="$1"
  local app_name="$2"
  local download_url="$3"
  
  while [ ! -d "$app_path" ]; do
    local key
    # if key is not set, prompt the user to install the app
    if [ -z "$key" ]; then
      echo "$app_name is not installed. Please install $app_name from $download_url."
      echo "Press o to open the $app_name download page in your browser."
      echo "Press any key to continue waiting for $app_name to be installed."
    fi
    read -n 1 -s key
    if [ "$key" = "o" ]; then
        open "$download_url"
    fi
  done
  echo "$app_name is installed. Continuing with the setup..."
}

# Wait for 1Password installation
wait_for_app "/Applications/1Password.app" "1Password" "https://1password.com/downloads/mac/"

# Wait for Xcode installation
wait_for_app "/Applications/Xcode.app" "Xcode" "https://developer.apple.com/download/"

# Array of install configurations: "verify_func:install_func:action_msg:completion_msg:error_suffix"
install_configs=(
  "verify_link_dotfiles:link_dotfiles:Linking dotfiles...:Dotfiles linked...:Please check the Dotfiles directory and try again."
  "verify_configure_defaults:configure_defaults:Configuring system defaults...:System defaults have been configured...:Please check the configuration script and try again."
  "verify_link_xcode_theme:link_xcode_theme:Linking Xcode theme...:Xcode theme has been linked...:Please check the theme files and try again."
  "verify_install_node:install_node:Node.js is not installed. Installing Node.js...:Node.js has been installed...:Please check your internet connection and try again."
  "verify_install_jenv:install_jenv:Java is not installed. Installing Java...:Java has been installed...:Please check your internet connection and try again."
  "verify_install_rbenv:install_rbenv:Ruby is not installed. Installing Ruby...:Ruby has been installed...:Please check your internet connection and try again."
  "verify_install_python:install_python:Python is not installed. Installing Python...:Python has been installed...:Please check your internet connection and try again."
  "verify_install_fish:install_fish:Fish shell is not installed. Installing Fish shell...:Fish shell has been installed...:Please check your internet connection and try again."
)

# Check Homebrew installation
if ! verify_install_brew; then
  if [ $? -eq 2 ]; then
    echo "Brewfile is partially installed or needs updating. Would you like to handle this now? (y/n)"
    read -n 1 -s key
    if [ "$key" = "y" ]; then
      echo "Updating Brewfile..."
      # Update the Brewfile
      if brew bundle update; then
        echo "Brewfile updated successfully."
      else
        echo "Failed to update Brewfile. Please check the Brewfile for issues."
        exit 1
      fi
    fi
  else
    if ! install_brew; then
      echo "Failed to install Homebrew. Please check your internet connection and try again."
      exit 1
    fi
  fi
fi
echo "Homebrew and Brewfile have been installed..."

# Process all other installations using the generic handler
for config in "${install_configs[@]}"; do
  IFS=':' read -r verify_func install_func action_msg completion_msg error_suffix <<< "$config"
  
  # Skip dotfiles as it's already handled above
  if [ "$verify_func" = "verify_link_dotfiles" ]; then
    continue
  fi
  
  handle_install "$verify_func" "$install_func" "$action_msg" "$completion_msg" "$error_suffix"
done

# Final message
echo ""
echo "All tools and applications have been installed and configured successfully!"
echo "You can now start using your macOS development environment."
echo "Please restart your terminal or run 'exec fish' to start using Fish shell."
echo "If you have any issues, please check the installation scripts and the README file for troubleshooting steps."
echo ""
printMessage "Thank you for using kylejs macOS bootstrap!"  "$green"

