#!/usr/bin/env bash
#
# Script: rofi-launcher
# Description: Launch rofi scripts from a menu
# Dependencies: rofi
# Usage: ./rofi-launcher

# Set strict error handling
set -euo pipefail

# Configuration
SCRIPTS_DIR="$HOME/bin/dmenu"
SCRIPTS_PATTERN="*"
ROFI_PROMPT="Rofi scripts"

# Function: Check if required dependencies are installed
# Arguments: None
# Returns: 0 if successful, 1 if dependencies are missing
check_dependencies() {
    if ! command -v rofi >/dev/null 2>&1; then
        echo "Error: rofi is not installed." >&2
        return 1
    fi

    if ! [ -d "$SCRIPTS_DIR" ]; then
        echo "Error: Scripts directory not found: $SCRIPTS_DIR" >&2
        return 1
    fi

    return 0
}

# Function: Get list of available rofi scripts
# Arguments: None
# Returns: Array of script names
get_script_names() {
    local -a source_files=("$SCRIPTS_DIR"/$SCRIPTS_PATTERN)
    local -a names=()

    # Check if any scripts were found
    if [ ! -e "${source_files[0]}" ]; then
        echo "Error: No rofi scripts found in $SCRIPTS_DIR" >&2
        exit 1
    fi

    # Extract script names from full paths
    for script_path in "${source_files[@]}"; do
        names+=("$(basename "$script_path")")
    done

    printf '%s\n' "${names[@]}"
}

# Function: Get full path of selected script
# Arguments: $1 - Script name
# Returns: Full path of the script
get_script_path() {
    local script_name="$1"
    local full_path="$SCRIPTS_DIR/$script_name"

    if [ ! -f "$full_path" ]; then
        echo "Error: Script not found: $full_path" >&2
        return 1
    fi

    if [ ! -x "$full_path" ]; then
        echo "Error: Script is not executable: $full_path" >&2
        return 1
    fi

    echo "$full_path"
}

# Function: Launch script using rofi
# Arguments: None
# Returns: 0 on success, 1 on failure
launch_script() {
    local script_names
    script_names=$(get_script_names)

    # Show menu and get user selection
    local choice
    choice=$(echo "$script_names" | rofi -dmenu -p "$ROFI_PROMPT")

    # Exit if no selection was made
    [ -n "$choice" ] || return 0

    # Get and validate script path
    local script_path
    script_path=$(get_script_path "$choice") || return 1

    # Execute the chosen script
    exec "$script_path"
}

# Function: Main program logic
# Arguments: None
# Returns: 0 on success, 1 on failure
main() {
    # Check dependencies
    check_dependencies || exit 1

    # Launch script selection menu
    launch_script

    return 0
}

# Run main program
main
