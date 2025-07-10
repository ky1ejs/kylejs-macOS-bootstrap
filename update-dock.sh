#!/bin/bash

# ask if work or personal machine
echo "Is this a personal or work machine? (p/w)"
while true; do
  read -r machine_type
  case "$machine_type" in
    [Pp]* ) machine_type="personal"; break;;
    [Ww]* ) machine_type="work"; break;;
    * ) echo "Please answer p or w.";;
  esac
done

echo "You selected: $machine_type machine"

if [ "$machine_type" = "personal" ]; then
  cp ~/Library/Preferences/com.apple.dock.plist plists/com.apple.dock.plist.personal
else 
  cp ~/Library/Preferences/com.apple.dock.plist plists/com.apple.dock.plist.work
fi