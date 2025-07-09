#!/bin/bash

export red=`tput setaf 1`
export green=`tput setaf 2`
export reset=`tput sgr0`

function startNewSection() {
  printf "\n\n################################################################################\n"
}

function printMessage {
  color=$2
  if [ -z "$color" ]; then color=$reset; fi
  printf "$color$1${reset}\n"
}

function exists() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}
