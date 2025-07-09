#! /bin/bash

source functions.sh

# Verification function for dotfiles linking
function verify_link_dotfiles() {
    # Check bin directory link
    if [ -d "$PWD/bin" ]; then
        if [ ! -L "$HOME/bin" ] || [ "$(readlink "$HOME/bin")" != "$PWD/bin" ]; then
            return 1  # Not completed
        fi
    fi
    
    # Check dotfiles links
    if [ -d "Dotfiles" ]; then
        for file_path in $(find Dotfiles -mindepth 1 -maxdepth 1 2>/dev/null); do
            local file=${file_path#Dotfiles/}
            local home_path="$HOME/$file"
            local full_path="$PWD/$file_path"
            
            if [ ! -L "$home_path" ] || [ "$(readlink "$home_path")" != "$full_path" ]; then
                return 1  # Not completed
            fi
        done
    fi
    
    return 0  # Fully completed
}

function link_dotfiles() {
    startNewSection
    local pwd_dir="$PWD"
    local dotfiles_dir="Dotfiles"
    
    # Link bin directory if it exists
    if [ -d "$pwd_dir/bin" ]; then
        local bin_target="$HOME/bin"
        if [ -e "$bin_target" ]; then
            if [ -L "$bin_target" ]; then
                # Remove existing symlink
                rm "$bin_target"
            else
                # Backup existing file/directory
                mv "$bin_target" "$bin_target.backup.$(date +%Y%m%d_%H%M%S)"
                echo "Backed up existing $bin_target"
            fi
        fi
        ln -s "$pwd_dir/bin" "$bin_target"
        echo "Linked bin directory"
    fi
    
    # Process dotfiles if directory exists
    if [ -d "$dotfiles_dir" ]; then
        for file_path in $(find "$dotfiles_dir" -mindepth 1 -maxdepth 1 2>/dev/null); do
            local file="${file_path#$dotfiles_dir/}"
            local home_path="$HOME/$file"
            local full_path="$pwd_dir/$file_path"
            
            # Skip if source file doesn't exist
            if [ ! -e "$full_path" ]; then
                echo "Warning: Source file $full_path does not exist, skipping"
                continue
            fi
            
            # Handle existing target
            if [ -e "$home_path" ]; then
                if [ -L "$home_path" ]; then
                    # Remove existing symlink
                    rm "$home_path"
                else
                    # Backup existing file/directory
                    mv "$home_path" "$home_path.backup.$(date +%Y%m%d_%H%M%S)"
                    echo "Backed up existing $home_path"
                fi
            fi
            
            # Create symlink
            ln -s "$full_path" "$home_path"
            echo "Linked $file"
        done
    else
        echo "Warning: Dotfiles directory not found"
    fi
}
