#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Desktop Entry Generator
# A standalone utility to create .desktop files for Wayland/X11.
# ==============================================================================

# --- Constants & Configuration ---
readonly DIR_APPS="$HOME/.local/share/applications"

# Colors
readonly CLR_GREEN='\033[0;32m'
readonly CLR_BLUE='\033[0;34m'
readonly CLR_YELLOW='\033[1;33m'
readonly CLR_RED='\033[0;31m'
readonly CLR_RESET='\033[0m'

# --- Helper Functions ---

print_banner() {
    clear
    echo -e "${CLR_BLUE}=======================================${CLR_RESET}"
    echo -e "${CLR_BLUE}    Desktop Entry Generator (BASH)     ${CLR_RESET}"
    echo -e "${CLR_BLUE}=======================================${CLR_RESET}"
    echo ""
}

resolve_path() {
    local path="$1"
    echo "${path/#\~/$HOME}"
}

sanitize_filename() {
    local name="$1"
    echo "$name" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -cd '[:alnum:]-'
}

# --- Core Logic Functions ---

get_user_input() {
    # 1. Basic Metadata
    local input_name input_comment input_categories raw_icon

    read -rp "Enter Application Name (e.g., My App): " input_name
    read -rp "Enter Comment/Description: " input_comment
    read -rp "Enter Category (e.g., Utility;Development;): " input_categories

    # Set defaults (Assigned to variables in Main scope)
    app_categories="${input_categories:-Utility;}"
    app_name="$input_name"
    app_comment="$input_comment"

    # 2. Executable Path
    read -rp "Enter absolute path to Executable: " raw_exec
    app_exec=$(resolve_path "$raw_exec")

    if [[ ! -f "$app_exec" ]]; then
        echo -e "${CLR_RED}Error: The file '$app_exec' does not exist.${CLR_RESET}"
        return 1
    fi

    # 3. Icon Path
    read -rp "Enter absolute path to Icon (optional): " raw_icon
    app_icon=$(resolve_path "$raw_icon")

    return 0
}

detect_environment() {
    extra_flags=""

    if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
        echo -e "\n${CLR_GREEN}Wayland session detected.${CLR_RESET}"
        read -rp "Is this an Electron/Chromium app? (y/n): " is_electron

        if [[ "$is_electron" =~ ^[yY]$ ]]; then
            echo "-> Adding Wayland-native flags (Ozone Platform)..."
            extra_flags=" --enable-features=UseOzonePlatform --ozone-platform=wayland"
        fi
    else
        echo -e "\n${CLR_BLUE}X11 session detected.${CLR_RESET}"
    fi
}

edit_file() {
    local target="$1"
    local editor="${EDITOR:-vim}" # Default to vim if EDITOR is unset
    local response

    echo ""
    read -rp "Do you want to edit the desktop entry now? (y/N) " response

    if [[ "$response" =~ ^[yY]$ ]]; then
        echo -e "Opening with ${editor}..."
        # run directly in current shell; no need for setsid/new terminal
        "$editor" "$target"
    fi
}

generate_file() {
    local file_name target_file

    file_name=$(sanitize_filename "$app_name")
    target_file="${DIR_APPS}/${file_name}.desktop"

    echo -e "\nGenerating file at: ${CLR_YELLOW}${target_file}${CLR_RESET}"

    # Ensure directory exists
    mkdir -p "$DIR_APPS"

    # Write content using Here-Doc
    cat >"$target_file" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${app_name}
Comment=${app_comment}
Exec=${app_exec}${extra_flags}
Icon=${app_icon}
Terminal=false
Categories=${app_categories}
StartupNotify=true
EOF

    chmod +x "$target_file"
    echo -e "${CLR_GREEN}Success! Entry created.${CLR_RESET}"

    # Offer to edit
    edit_file "$target_file"
}

# --- Main Entry Point ---

main() {
    # Initialize variables (Implicitly passed to functions via dynamic scoping)
    local app_name=""
    local app_comment=""
    local app_categories=""
    local app_exec=""
    local app_icon=""
    local extra_flags=""

    print_banner

    # Run input; exit if it returns non-zero (file not found)
    if ! get_user_input; then
        echo -e "${CLR_RED}Aborting script.${CLR_RESET}"
        exit 1
    fi

    detect_environment
    generate_file
}

main
