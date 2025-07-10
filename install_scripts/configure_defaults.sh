#!/bin/sh

source functions.sh

# Verification function for system defaults configuration
function verify_configure_defaults() {
    # Check key directories
    if [ ! -d "$HOME/Developer" ] || [ ! -d "$HOME/Developer/kylejs" ]; then
        return 1  # Not completed
    fi
    
    # Check critical defaults
    local xcode_duration=$(defaults read com.apple.dt.Xcode ShowBuildOperationDuration 2>/dev/null)
    if [ "$xcode_duration" != "1" ]; then
        return 1  # Not completed
    fi
    
    # Check screenshot location
    local screenshot_loc=$(defaults read com.apple.screencapture location 2>/dev/null)
    if [ "$screenshot_loc" != "$HOME/Downloads" ]; then
        return 1  # Not completed
    fi
    
    # Check if plist files have been copied
    if [ ! -f "$HOME/Library/Preferences/com.apple.dock.plist" ] || \
       [ ! -f "$HOME/Library/Preferences/com.apple.finder.plist" ] || \
       [ ! -f "$HOME/Library/Preferences/com.apple.Terminal.plist" ]; then
        return 2  # Partially completed
    fi
    
    return 0  # Fully completed
}

function configure_defaults() {
    startNewSection
    
    if verify_configure_defaults; then
        printMessage "System defaults are already configured" "$green"
        return 0
    fi

    # Proceed with configuration
    printMessage "Configuring system defaults and preferences" "$green"
    
    # Create necessary directories
    mkdir -p "$HOME/Developer/kylejs"

    # Set Xcode build operation duration preference
    defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES

    # Set screenshot location
    defaults write com.apple.screencapture location ~/Downloads
    killall SystemUIServer

    # Copy plist files for Dock, Finder, and Terminal

    # Copy relevant dock based on machine type
    local dock_plist_path="$HOME/Library/Preferences/com.apple.dock.plist"
    if [[ "$MACHINE_TYPE" == "work" ]]; then
        cp -f plists/com.apple.dock.plist.work "$dock_plist_path"
    else
        cp -f plists/com.apple.dock.plist.personal "$dock_plist_path"
    fi

    cp -f plists/com.apple.finder.plist ~/Library/Preferences/com.apple.finder.plist
    killall Finder

    cp -f plists/com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist
    cp -f plists/com.apple.Terminal.plist ~/Library/Preferences/com.apple.Safari.plist

    # Set up quick look for provisioning profiles
    if ! $(exists "brew"); then
        printMessage "Homebrew needs to be installed to setup provisioning profile quick look" "$red"
        exit 1
    fi

    printMessage "Setting up quick look for provisioning profiles" "$green"
    defaults write com.apple.finder QLEnableTextSelection -bool TRUE
    killall Finder

    return 0  # Success
}
