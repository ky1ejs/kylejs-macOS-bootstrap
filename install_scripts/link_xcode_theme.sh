#!/bin/bash

source functions.sh

THEME_LOCATION=$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/

# Verification function for Xcode theme linking
function verify_link_xcode_theme() {
    # Check if Xcode theme directory exists
    if [ ! -d "$THEME_LOCATION" ]; then
        return 1  # Not completed - Xcode not installed
    fi
    
    # Check if theme file is linked
    local theme_file="$THEME_LOCATION/kylejs.xccolortheme"
    if [ ! -L "$theme_file" ]; then
        return 1  # Not completed - theme not linked
    fi
    
    # Check if link points to correct source
    local expected_source="$PWD/Applications/xcode/kylejs.xccolortheme"
    if [ "$(readlink "$theme_file")" != "$expected_source" ]; then
        return 1  # Not completed - incorrect link
    fi
    
    return 0  # Fully completed
}

function link_xcode_theme() {
    startNewSection
    
    if verify_link_xcode_theme; then
        printMessage "Xcode theme is already linked" "$green"
        exit 0
    fi

    # Check for Xcode dependency
    if [ ! -d /Applications/Xcode.app ]; then
        handleError "Xcode needs to be installed to set the theme"
    fi

    printMessage "Linking Xcode theme" "$green"

    # Create theme directory if it doesn't exist
    mkdir -p $THEME_LOCATION

    # Remove existing theme file if it exists
    if [ -L "$THEME_LOCATION/kylejs.xccolortheme" ];
    then
        rm "$THEME_LOCATION/kylejs.xccolortheme"
    elif [ -f "$THEME_LOCATION/kylejs.xccolortheme" ]; then
        printMessage "Removing existing theme file at $THEME_LOCATION/kylejs.xccolortheme" "$yellow"
        rm "$THEME_LOCATION/kylejs.xccolortheme"
    fi

    # Link the theme file
    ln -s $PWD/Applications/xcode/kylejs.xccolortheme $THEME_LOCATION/
}
