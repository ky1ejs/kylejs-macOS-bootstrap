#!/bin/bash

source functions.sh

THEME_LOCATION = $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/

if [ ! -d THEME_LOCATION ]; then
	printMessage "Xcode not installed, please install to set theme"
	exit 0
fi

ln -s $PWD/kylejm.xccolortheme $THEME_LOCATION