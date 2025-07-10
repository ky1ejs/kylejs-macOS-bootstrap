# Flag to track if screen needs refresh
SCREEN_NEEDS_REFRESH=false

# Signal handler for window resize
handle_resize() {
    update_terminal_size
    SCREEN_NEEDS_REFRESH=true
}

# Function to check if terminal size is adequate
check_terminal_size() {
    if [ $TERM_WIDTH -lt 30 ] || [ $TERM_HEIGHT -lt 15 ]; then
        cleanup_terminal
        echo -e "${RED}${BOLD}Error: Terminal too small!${RESET}"
        echo -e "${YELLOW}Minimum size: 30 columns x 15 rows${RESET}"
        echo -e "${YELLOW}Current size: $TERM_WIDTH columns x $TERM_HEIGHT rows${RESET}"
        echo ""
        echo "Please resize your terminal and try again."
        exit 1
    fi
}#!/bin/bash

# Colors (ANSI escape codes)
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
BLUE='\033[34m'
GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RED='\033[31m'
MAGENTA='\033[35m'
WHITE='\033[37m'
BG_BLUE='\033[44m'
BG_GREEN='\033[42m'

# Terminal control sequences
CLEAR_SCREEN='\033[2J'
MOVE_CURSOR_HOME='\033[H'
HIDE_CURSOR='\033[?25l'
SHOW_CURSOR='\033[?25h'
SAVE_CURSOR='\033[s'
RESTORE_CURSOR='\033[u'

# Get terminal dimensions
update_terminal_size() {
    TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
    TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
}

# Initialize terminal dimensions
update_terminal_size

# Menu items
declare -a MENU_ITEMS=(
    "Install Homebrew|Package manager for macOS"
    "Configure Git|Set up name, email, and SSH keys"
    "Install Development Tools|Xcode tools, Node.js, etc."
    "Install Applications|VS Code, Chrome, etc."
    "Configure Shell|Oh My Zsh, dotfiles, etc."
    "System Preferences|Dock, Finder, etc."
    "Show Installation Log|View what's been done"
    "Quit|Exit the setup script"
)

# Current selected menu item (0-based)
SELECTED_ITEM=0

# Function to center text with bounds checking
center_text() {
    local text="$1"
    local width=${2:-$TERM_WIDTH}
    local text_len=${#text}
    
    # If text is longer than terminal width, truncate it
    if [ $text_len -gt $width ]; then
        text="${text:0:$((width-3))}..."
        text_len=${#text}
    fi
    
    local padding=$(( (width - text_len) / 2 ))
    if [ $padding -lt 0 ]; then
        padding=0
    fi
    printf "%*s%s" $padding "" "$text"
}

# Function to move cursor to specific position
move_cursor() {
    local row=$1
    local col=$2
    printf "\033[%d;%dH" $row $col
}

# Function to clear from cursor to end of line
clear_line() {
    printf "\033[K"
}

# Function to setup terminal for interactive mode
setup_terminal() {
    # Set up signal handler for window resize
    trap 'handle_resize' WINCH
    
    # Check initial terminal size
    check_terminal_size
    
    # Disable line buffering and echo
    stty -echo -icanon min 1 time 0
    # Hide cursor
    printf "${HIDE_CURSOR}"
    # Clear screen
    printf "${CLEAR_SCREEN}${MOVE_CURSOR_HOME}"
}

# Function to restore terminal settings
cleanup_terminal() {
    # Remove signal handlers
    trap - WINCH EXIT INT TERM
    # Show cursor
    printf "${SHOW_CURSOR}"
    # Restore normal terminal settings
    stty echo icanon
    # Clear screen and move to top
    printf "${CLEAR_SCREEN}${MOVE_CURSOR_HOME}"
}

# Function to draw the banner
draw_banner() {
    local banner_width=$((TERM_WIDTH < 70 ? TERM_WIDTH - 4 : 66))
    local border_char="═"
    local side_char="║"
    
    # Create responsive border
    local top_border="╔$(printf "%*s" $((banner_width-2)) | tr ' ' "$border_char")╗"
    local bottom_border="╚$(printf "%*s" $((banner_width-2)) | tr ' ' "$border_char")╝"
    local empty_line="$side_char$(printf "%*s" $((banner_width-2)) | tr ' ' ' ')$side_char"
    
    move_cursor 2 1
    echo -e "${CYAN}${BOLD}"
    center_text "$top_border"
    echo
    center_text "$empty_line"
    echo
    
    # Responsive title
    if [ $TERM_WIDTH -ge 50 ]; then
        center_text "$side_char                        🍎 Mac Setup Script                     $side_char"
    else
        center_text "$side_char           Mac Setup           $side_char"
    fi
    echo
    center_text "$empty_line"
    echo
    
    echo -e "${CYAN}${DIM}"
    if [ $TERM_WIDTH -ge 60 ]; then
        center_text "$side_char                   Configure your new Mac with ease             $side_char"
    else
        center_text "$side_char        Configure your Mac        $side_char"
    fi
    echo
    
    echo -e "${CYAN}${BOLD}"
    center_text "$empty_line"
    echo
    center_text "$bottom_border"
    echo -e "${RESET}"
}

# Function to draw menu items
draw_menu() {
    local start_row=12
    local max_title_width=$((TERM_WIDTH < 80 ? TERM_WIDTH / 3 : 25))
    local max_desc_width=$((TERM_WIDTH - max_title_width - 10))
    
    # Ensure minimum widths
    if [ $max_title_width -lt 10 ]; then max_title_width=10; fi
    if [ $max_desc_width -lt 15 ]; then max_desc_width=15; fi
    
    move_cursor $start_row 1
    echo -e "${BOLD}${BLUE}"
    if [ $TERM_WIDTH -ge 50 ]; then
        center_text "Use ↑/↓ arrow keys to navigate, Enter to select"
    else
        center_text "↑/↓ to navigate, Enter to select"
    fi
    echo -e "${RESET}"
    echo
    
    for i in "${!MENU_ITEMS[@]}"; do
        local item="${MENU_ITEMS[$i]}"
        local title="${item%%|*}"
        local description="${item##*|}"
        local row=$((start_row + 3 + i))
        
        # Truncate title and description if needed
        if [ ${#title} -gt $max_title_width ]; then
            title="${title:0:$((max_title_width-3))}..."
        fi
        if [ ${#description} -gt $max_desc_width ]; then
            description="${description:0:$((max_desc_width-3))}..."
        fi
        
        move_cursor $row 1
        
        if [ $i -eq $SELECTED_ITEM ]; then
            # Highlighted item - responsive format
            if [ $TERM_WIDTH -ge 60 ]; then
                printf "${BG_BLUE}${WHITE}${BOLD} ▶ %-${max_title_width}s ${RESET}" "$title"
                printf "${DIM} %s${RESET}" "$description"
            else
                printf "${BG_BLUE}${WHITE}${BOLD} ▶ %s ${RESET}" "$title"
                echo
                move_cursor $((row + 1)) 3
                printf "${DIM}%s${RESET}" "$description"
            fi
        else
            # Normal item - responsive format
            if [ $TERM_WIDTH -ge 60 ]; then
                printf "${GREEN}   %-${max_title_width}s ${RESET}" "$title"
                printf "${DIM} %s${RESET}" "$description"
            else
                printf "${GREEN}   %s ${RESET}" "$title"
                echo
                move_cursor $((row + 1)) 3
                printf "${DIM}%s${RESET}" "$description"
            fi
        fi
        clear_line
        
        # Add extra line for narrow terminals
        if [ $TERM_WIDTH -lt 60 ]; then
            echo
        fi
    done
    
    # Instructions at bottom
    local bottom_row=$((start_row + 3 + ${#MENU_ITEMS[@]} + (TERM_WIDTH < 60 ? ${#MENU_ITEMS[@]} : 0) + 2))
    move_cursor $bottom_row 1
    echo -e "${DIM}"
    center_text "Press 'q' to quit at any time"
    echo -e "${RESET}"
}

# Function to read a single key with timeout
read_key() {
    local key
    # Use timeout to allow checking for screen refresh
    if read -rsn1 -t 0.1 key; then
        # Handle escape sequences (arrow keys)
        if [[ $key == 

# Function to update the display
update_display() {
    # Clear screen and reset cursor
    printf "${CLEAR_SCREEN}${MOVE_CURSOR_HOME}"
    draw_banner
    draw_menu
    SCREEN_NEEDS_REFRESH=false
}

# Function to show a confirmation dialog
show_confirmation() {
    local message="$1"
    local start_row=$((TERM_HEIGHT - 8))
    local dialog_width=$((TERM_WIDTH < 65 ? TERM_WIDTH - 4 : 61))
    local border_char="─"
    
    # Create responsive dialog box
    local top_border="┌$(printf "%*s" $((dialog_width-2)) | tr ' ' "$border_char")┐"
    local bottom_border="└$(printf "%*s" $((dialog_width-2)) | tr ' ' "$border_char")┘"
    local empty_line="│$(printf "%*s" $((dialog_width-2)) | tr ' ' ' ')│"
    
    # Truncate message if needed
    local max_msg_width=$((dialog_width - 6))
    if [ ${#message} -gt $max_msg_width ]; then
        message="${message:0:$((max_msg_width-3))}..."
    fi
    
    # Draw confirmation box
    move_cursor $start_row 1
    echo -e "${YELLOW}${BOLD}"
    center_text "$top_border"
    echo
    center_text "$empty_line"
    echo
    center_text "│  $message$(printf "%*s" $((dialog_width - ${#message} - 4)) | tr ' ' ' ')│"
    echo
    center_text "$empty_line"
    echo
    if [ $TERM_WIDTH -ge 50 ]; then
        center_text "│            Press 'y' to confirm, 'n' to cancel             │"
    else
        center_text "│        'y' confirm, 'n' cancel        │"
    fi
    echo
    center_text "$empty_line"
    echo
    center_text "$bottom_border"
    echo -e "${RESET}"
    
    while true; do
        local key=$(read_key)
        case $key in
            'y'|'Y') return 0 ;;
            'n'|'N'|'ESCAPE') return 1 ;;
        esac
    done
}

# Function to show progress with a progress bar
show_progress() {
    local message="$1"
    local duration="${2:-5}"
    local start_row=$((TERM_HEIGHT - 6))
    local dialog_width=$((TERM_WIDTH < 65 ? TERM_WIDTH - 4 : 61))
    local progress_width=$((dialog_width - 10))
    local border_char="─"
    
    # Ensure minimum progress bar width
    if [ $progress_width -lt 10 ]; then
        progress_width=10
    fi
    
    # Truncate message if needed
    local max_msg_width=$((dialog_width - 6))
    if [ ${#message} -gt $max_msg_width ]; then
        message="${message:0:$((max_msg_width-3))}..."
    fi
    
    for ((i=0; i<=duration; i++)); do
        local percent=$((i * 100 / duration))
        local filled=$((percent * progress_width / 100))
        local empty=$((progress_width - filled))
        
        local top_border="┌$(printf "%*s" $((dialog_width-2)) | tr ' ' "$border_char")┐"
        local bottom_border="└$(printf "%*s" $((dialog_width-2)) | tr ' ' "$border_char")┘"
        
        move_cursor $start_row 1
        echo -e "${BLUE}${BOLD}"
        center_text "$top_border"
        echo
        center_text "│  $message$(printf "%*s" $((dialog_width - ${#message} - 4)) | tr ' ' ' ')│"
        echo
        printf "${BLUE}"
        center_text "│  ["
        printf "${GREEN}"
        printf "%*s" $filled | tr ' ' '█'
        printf "${DIM}"
        printf "%*s" $empty | tr ' ' '░'
        printf "${BLUE}"
        printf "] %3d%%$(printf "%*s" $((dialog_width - progress_width - 12)) | tr ' ' ' ')│" $percent
        echo
        center_text "$bottom_border"
        echo -e "${RESET}"
        
        sleep 1
    done
    
    # Show completion
    move_cursor $((start_row + 2)) 1
    echo -e "${GREEN}${BOLD}"
    center_text "✓ Completed!"
    echo -e "${RESET}"
    sleep 1
}

# Function to log actions
log_action() {
    local action="$1"
    local log_file="$HOME/mac-setup.log"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $action" >> "$log_file"
}

# Installation functions
install_homebrew() {
    if show_confirmation "Install Homebrew package manager?"; then
        show_progress "Installing Homebrew..." 5
        log_action "Homebrew installation started"
        
        # Check if Homebrew is already installed
        if command -v brew >/dev/null 2>&1; then
            log_action "Homebrew already installed"
        else
            # Install Homebrew (commented out for demo)
            # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            log_action "Homebrew installation completed"
        fi
    fi
}

configure_git() {
    if show_confirmation "Configure Git settings?"; then
        # For demo purposes, we'll just show progress
        show_progress "Configuring Git..." 3
        log_action "Git configuration completed"
    fi
}

install_dev_tools() {
    if show_confirmation "Install development tools?"; then
        show_progress "Installing development tools..." 4
        log_action "Development tools installation completed"
    fi
}

install_applications() {
    if show_confirmation "Install applications?"; then
        show_progress "Installing applications..." 4
        log_action "Applications installation completed"
    fi
}

configure_shell() {
    if show_confirmation "Configure shell environment?"; then
        show_progress "Configuring shell..." 3
        log_action "Shell configuration completed"
    fi
}

configure_system() {
    if show_confirmation "Configure system preferences?"; then
        show_progress "Configuring system..." 3
        log_action "System configuration completed"
    fi
}

show_log() {
    local log_file="$HOME/mac-setup.log"
    local start_row=5
    
    move_cursor $start_row 1
    echo -e "${BLUE}${BOLD}"
    center_text "Installation Log"
    echo -e "${RESET}"
    echo
    
    if [[ -f "$log_file" ]]; then
        # Show last 10 lines of log
        tail -10 "$log_file" | while IFS= read -r line; do
            center_text "$line"
            echo
        done
    else
        center_text "No installation log found."
        echo
    fi
    
    echo
    echo -e "${DIM}"
    center_text "Press any key to continue..."
    echo -e "${RESET}"
    
    read_key > /dev/null
}

quit_script() {
    cleanup_terminal
    echo -e "${GREEN}${BOLD}Thanks for using Mac Setup Script!${RESET}"
    echo -e "${DIM}Log file saved to: $HOME/mac-setup.log${RESET}"
    echo
    exit 0
}

# Main program
main() {
    # Set up terminal
    setup_terminal
    
    # Set up cleanup on exit
    trap cleanup_terminal EXIT INT TERM
    
    # Initial display
    update_display
    
    # Main loop
    while true; do
        # Check if screen needs refresh due to resize
        if [ "$SCREEN_NEEDS_REFRESH" = true ]; then
            check_terminal_size
            update_display
        fi
        
        local key=$(read_key)
        
        case $key in
            "UP")
                if [ $SELECTED_ITEM -gt 0 ]; then
                    ((SELECTED_ITEM--))
                    update_display
                fi
                ;;
            "DOWN")
                if [ $SELECTED_ITEM -lt $((${#MENU_ITEMS[@]} - 1)) ]; then
                    ((SELECTED_ITEM++))
                    update_display
                fi
                ;;
            "ENTER")
                case $SELECTED_ITEM in
                    0) install_homebrew ;;
                    1) configure_git ;;
                    2) install_dev_tools ;;
                    3) install_applications ;;
                    4) configure_shell ;;
                    5) configure_system ;;
                    6) show_log ;;
                    7) quit_script ;;
                esac
                update_display
                ;;
            "QUIT")
                quit_script
                ;;
            "TIMEOUT")
                # Continue loop to check for screen refresh
                ;;
        esac
    done
}

# Run the main program
main\x1b' ]]; then
            read -rsn2 key
            case $key in
                '[A') echo "UP" ;;
                '[B') echo "DOWN" ;;
                '[C') echo "RIGHT" ;;
                '[D') echo "LEFT" ;;
                *) echo "ESCAPE" ;;
            esac
        else
            case $key in
                '') echo "ENTER" ;;
                'q'|'Q') echo "QUIT" ;;
                ' ') echo "SPACE" ;;
                *) echo "$key" ;;
            esac
        fi
    else
        echo "TIMEOUT"
    fi
}

# Function to update the display
update_display() {
    # Clear screen and reset cursor
    printf "${CLEAR_SCREEN}${MOVE_CURSOR_HOME}"
    draw_banner
    draw_menu
    SCREEN_NEEDS_REFRESH=false
}

# Function to show a confirmation dialog
show_confirmation() {
    local message="$1"
    local start_row=$((TERM_HEIGHT - 8))
    local dialog_width=$((TERM_WIDTH < 65 ? TERM_WIDTH - 4 : 61))
    local border_char="─"
    
    # Create responsive dialog box
    local top_border="┌$(printf "%*s" $((dialog_width-2)) | tr ' ' "$border_char")┐"
    local bottom_border="└$(printf "%*s" $((dialog_width-2)) | tr ' ' "$border_char")┘"
    local empty_line="│$(printf "%*s" $((dialog_width-2)) | tr ' ' ' ')│"
    
    # Truncate message if needed
    local max_msg_width=$((dialog_width - 6))
    if [ ${#message} -gt $max_msg_width ]; then
        message="${message:0:$((max_msg_width-3))}..."
    fi
    
    # Draw confirmation box
    move_cursor $start_row 1
    echo -e "${YELLOW}${BOLD}"
    center_text "$top_border"
    echo
    center_text "$empty_line"
    echo
    center_text "│  $message$(printf "%*s" $((dialog_width - ${#message} - 4)) | tr ' ' ' ')│"
    echo
    center_text "$empty_line"
    echo
    if [ $TERM_WIDTH -ge 50 ]; then
        center_text "│            Press 'y' to confirm, 'n' to cancel             │"
    else
        center_text "│        'y' confirm, 'n' cancel        │"
    fi
    echo
    center_text "$empty_line"
    echo
    center_text "$bottom_border"
    echo -e "${RESET}"
    
    while true; do
        local key=$(read_key)
        case $key in
            'y'|'Y') return 0 ;;
            'n'|'N'|'ESCAPE') return 1 ;;
        esac
    done
}

# Function to show progress with a progress bar
show_progress() {
    local message="$1"
    local duration="${2:-5}"
    local start_row=$((TERM_HEIGHT - 6))
    local dialog_width=$((TERM_WIDTH < 65 ? TERM_WIDTH - 4 : 61))
    local progress_width=$((dialog_width - 10))
    local border_char="─"
    
    # Ensure minimum progress bar width
    if [ $progress_width -lt 10 ]; then
        progress_width=10
    fi
    
    # Truncate message if needed
    local max_msg_width=$((dialog_width - 6))
    if [ ${#message} -gt $max_msg_width ]; then
        message="${message:0:$((max_msg_width-3))}..."
    fi
    
    for ((i=0; i<=duration; i++)); do
        local percent=$((i * 100 / duration))
        local filled=$((percent * progress_width / 100))
        local empty=$((progress_width - filled))
        
        local top_border="┌$(printf "%*s" $((dialog_width-2)) | tr ' ' "$border_char")┐"
        local bottom_border="└$(printf "%*s" $((dialog_width-2)) | tr ' ' "$border_char")┘"
        
        move_cursor $start_row 1
        echo -e "${BLUE}${BOLD}"
        center_text "$top_border"
        echo
        center_text "│  $message$(printf "%*s" $((dialog_width - ${#message} - 4)) | tr ' ' ' ')│"
        echo
        printf "${BLUE}"
        center_text "│  ["
        printf "${GREEN}"
        printf "%*s" $filled | tr ' ' '█'
        printf "${DIM}"
        printf "%*s" $empty | tr ' ' '░'
        printf "${BLUE}"
        printf "] %3d%%$(printf "%*s" $((dialog_width - progress_width - 12)) | tr ' ' ' ')│" $percent
        echo
        center_text "$bottom_border"
        echo -e "${RESET}"
        
        sleep 1
    done
    
    # Show completion
    move_cursor $((start_row + 2)) 1
    echo -e "${GREEN}${BOLD}"
    center_text "✓ Completed!"
    echo -e "${RESET}"
    sleep 1
}

# Function to log actions
log_action() {
    local action="$1"
    local log_file="$HOME/mac-setup.log"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $action" >> "$log_file"
}

# Installation functions
install_homebrew() {
    if show_confirmation "Install Homebrew package manager?"; then
        show_progress "Installing Homebrew..." 5
        log_action "Homebrew installation started"
        
        # Check if Homebrew is already installed
        if command -v brew >/dev/null 2>&1; then
            log_action "Homebrew already installed"
        else
            # Install Homebrew (commented out for demo)
            # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            log_action "Homebrew installation completed"
        fi
    fi
}

configure_git() {
    if show_confirmation "Configure Git settings?"; then
        # For demo purposes, we'll just show progress
        show_progress "Configuring Git..." 3
        log_action "Git configuration completed"
    fi
}

install_dev_tools() {
    if show_confirmation "Install development tools?"; then
        show_progress "Installing development tools..." 4
        log_action "Development tools installation completed"
    fi
}

install_applications() {
    if show_confirmation "Install applications?"; then
        show_progress "Installing applications..." 4
        log_action "Applications installation completed"
    fi
}

configure_shell() {
    if show_confirmation "Configure shell environment?"; then
        show_progress "Configuring shell..." 3
        log_action "Shell configuration completed"
    fi
}

configure_system() {
    if show_confirmation "Configure system preferences?"; then
        show_progress "Configuring system..." 3
        log_action "System configuration completed"
    fi
}

show_log() {
    local log_file="$HOME/mac-setup.log"
    local start_row=5
    
    move_cursor $start_row 1
    echo -e "${BLUE}${BOLD}"
    center_text "Installation Log"
    echo -e "${RESET}"
    echo
    
    if [[ -f "$log_file" ]]; then
        # Show last 10 lines of log
        tail -10 "$log_file" | while IFS= read -r line; do
            center_text "$line"
            echo
        done
    else
        center_text "No installation log found."
        echo
    fi
    
    echo
    echo -e "${DIM}"
    center_text "Press any key to continue..."
    echo -e "${RESET}"
    
    read_key > /dev/null
}

quit_script() {
    cleanup_terminal
    echo -e "${GREEN}${BOLD}Thanks for using Mac Setup Script!${RESET}"
    echo -e "${DIM}Log file saved to: $HOME/mac-setup.log${RESET}"
    echo
    exit 0
}

# Main program
main() {
    # Set up terminal
    setup_terminal
    
    # Set up cleanup on exit
    trap cleanup_terminal EXIT INT TERM
    
    # Initial display
    update_display
    
    # Main loop
    while true; do
        local key=$(read_key)
        
        case $key in
            "UP")
                if [ $SELECTED_ITEM -gt 0 ]; then
                    ((SELECTED_ITEM--))
                    update_display
                fi
                ;;
            "DOWN")
                if [ $SELECTED_ITEM -lt $((${#MENU_ITEMS[@]} - 1)) ]; then
                    ((SELECTED_ITEM++))
                    update_display
                fi
                ;;
            "ENTER")
                case $SELECTED_ITEM in
                    0) install_homebrew ;;
                    1) configure_git ;;
                    2) install_dev_tools ;;
                    3) install_applications ;;
                    4) configure_shell ;;
                    5) configure_system ;;
                    6) show_log ;;
                    7) quit_script ;;
                esac
                update_display
                ;;
            "QUIT")
                quit_script
                ;;
        esac
    done
}

# Run the main program
main