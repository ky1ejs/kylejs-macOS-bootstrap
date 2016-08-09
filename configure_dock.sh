#!/bin/sh

cp -f com.apple.dock.plist ~/Library/Preferences/com.apple.dock.plist

PROCESS=Dock
NUMBER=$(ps aux | grep $PROCESS | wc -l)
if [ $NUMBER -gt 0 ]; then
    killall $PROCESS
fi
