#!/bin/sh

source functions.sh

function killProcess {
  PROCESS=$1
  NUMBER=$(ps aux | grep $PROCESS | wc -l)
  if [ $NUMBER -gt 0 ]; then
      killall $PROCESS
  fi
}

printMessage "Setting up defaults and preferences"

if [ ! -d "$HOME/Developer" ]; then
  mkdir ~/Developer
fi

if [ ! -d "$HOME/Developer/kylejm" ]; then
  mkdir ~/Developer/kylejm
fi

defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES

defaults write com.apple.screencapture location ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Temp
killall SystemUIServer

cp -f plists/com.apple.dock.plist ~/Library/Preferences/com.apple.dock.plist
killall cfprefsd
killall Dock

cp -f plists/com.apple.finder.plist ~/Library/Preferences/com.apple.finder.plist
killall Finder

cp -f plists/com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist
cp -f plists/com.apple.Terminal.plist ~/Library/Preferences/com.apple.Safari.plist

if ! $(exists "brew"); then
  printMessage "Homebrew needs to be installed to setup provisioning profile quick look"
  exit 1
fi

printMessage "Setting up quick look for provisioning profiles"
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
killall Finder
