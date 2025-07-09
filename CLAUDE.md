# Intro

This repo serves to preserve and version control my personal macOS configuration, tools and applications. It includes a series of scripts that will install and configure various applications, tools, and settings to set up a new macOS install quickly.

# Usage
To get started, run:
```bash
./install.sh
```

# How it works
The `install.sh` script orchestrates the installation process by calling various other scripts in the correct order. Each script is responsible for installing and configuring a specific tool(s) and/or application(s). The scripts are designed to be idempotent, meaning they can be run multiple times without causing issues.

# Structure
The repo is structured as follows:
- `install.sh`: The main script that runs all the other scripts in the correct order.
- `Applications/`: Contains various files (e.g. `.plist` files) for configuring applications.
- `Dotfiles/`: Contains various dotfiles for configuring the shell and other tools. These files are symlinked to the home directory.
- `plists/`: Contains various `.plist` files for configuring system settings.
- `Brewfile`: A file that lists all the Homebrew packages and applications to be installed.
- `install_scripts/`: Contains various scripts for installing and configuring tools and applications.
- `functions.sh`: Contains various functions used by the installation scripts.
