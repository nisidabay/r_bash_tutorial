#!/usr/bin/env bash
#
# Activate/Deactivate virtual environments
# This script must be SOURCED to function correctly: source venv_toggle.sh
# --------------------------------------------------------------------------------
# Display Script Title
clear
echo "venv toggle"
sleep 1

# Checks if the programs passed as strings are installed
chk_dependencies() {
    local -a dependencies_array=("$@")
    local -a missing=()
    for program in "${dependencies_array[@]}"; do
        if ! command -v "$program" >/dev/null; then
            missing+=("$program")
        fi
    done
    if [[ "${#missing[@]}" -gt 0 ]]; then
        local missing_programs="${missing[*]}"
        echo "Install the missing dependencies before continuing: $missing_programs"
        osascript -e "display notification \"Install the following programs before continuing: $missing_programs\" with title \"Missing Dependencies\""
        exit 1
    fi
}

# Check if the script is being sourced or not
is_sourced() {
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        echo "This script must be sourced to function correctly"
        echo "Usage: source venv_toggle.sh"
        exit 1
    fi
}

# Select virtual environment
select_venv() {
    local search_dirs=(
        "$HOME/Documents"
        "$HOME/Projects"
        "$HOME/Desktop"
        "$HOME/Downloads"
        "$HOME/bin"
        # Add more directories here if needed
    )

    local selected_venv_path
    selected_venv_path=$(rg --files --hidden -g "pyvenv.cfg" "${search_dirs[@]}" 2>/dev/null | sed 's|/pyvenv.cfg$||' | fzf --height 60% --reverse)
    if [[ "$selected_venv_path" == "." ]]; then
        selected_venv_path=$(pwd)
    fi
    echo "$selected_venv_path"
}

# Activate venv
activate_venv() {
    local venv_path="$1"
    if [[ -n $venv_path ]]; then
        cd "$venv_path" || return
        source ./bin/activate
        echo "Activated virtual environment at $venv_path"
        cd - >/dev/null # Go back to the previous folder
    else
        echo "No virtual environment selected or found."
    fi
}

# Deactivate venv
deactivate_venv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        deactivate
        echo "Virtual environment deactivated."
    else
        echo "No virtual environment is currently active."
    fi
}

# Execution starts HERE
chk_dependencies "rg" "fzf"
is_sourced

if [[ -n $VIRTUAL_ENV ]]; then
    echo "A virtual environment is currently active."
    echo -n "Deactivate the virtual environment? (y/n) "
    read -r response
    if [[ $response =~ ^[Yy]$ ]]; then
        deactivate_venv
    fi
else
    echo "Select a virtual environment to activate:"
    VENV_PATH=$(select_venv)
    if [ -n "$VENV_PATH" ]; then
        activate_venv "$VENV_PATH"
    else
        echo "No virtual environment was selected."
    fi
fi
