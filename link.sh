#!/bin/bash
# Links Dotfiles/ and bin/ into $HOME, and does nothing else: no apps, no
# macOS defaults, no prompts. For a Mac whose apps and settings are set up
# another way, such as the homelab Mac Studio, which nix-darwin configures.
# It shares this repo's dotfiles with the laptop through the same links.
#
# Anything already at a link's path is moved to <path>.backup.<timestamp>.
cd "$(dirname "$0")" || exit 1
source functions.sh
source install_scripts/link_dotfiles.sh
link_dotfiles
