#!/usr/bin/env bash
#
# Convert a manual page to text on macOS

#!/usr/bin/env bash
#
# Convert a manual page to text on macOS

set -e

# Checks if the programs passed as strings are installed
chk_dependencies() {
    local -a dependencies_array=($@)
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

# Check for required commands
chk_dependencies "man" "col" "osascript" "timeout" "cat"


# Function to get user input
get_user_input() {
    local prompt="$1"
    local input
    read -p "$prompt" input
    echo "$input"
}

# Function to search man pages
search_man_pages() {
    local search_term="$1"
    man -k . | grep "^$search_term" | sort
}

# Get user input for the man page
while true; do
    search_term=$(get_user_input "Enter the beginning of the man page name (or press Enter to list all): ")
    if [ -z "$search_term" ]; then
        man_pages=$(man -k . | sort)
    else
        man_pages=$(search_man_pages "$search_term")
    fi

    if [ -z "$man_pages" ]; then
        echo "No man pages found starting with '$search_term'. Please try again."
    else
        break
    fi
done

# Display search results with line numbers
echo "Search results:"
echo "$man_pages" | nl -w4 -s') '

# Get user selection
while true; do
    selection=$(get_user_input "Enter the number of the man page you want to convert (or q to quit): ")
    if [ "$selection" = "q" ]; then
        echo "Exiting script."
        exit 0
    fi
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -le "$(echo "$man_pages" | wc -l)" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Extract the selected man page
selected_page=$(echo "$man_pages" | sed -n "${selection}p")
command_name=$(echo "$selected_page" | awk '{print $1}' | sed 's/(.*//')

echo "Attempting to convert man page for $command_name..."

# Convert man page to text with timeout and custom pager
if timeout 20s bash -c "MANPAGER='col -bx' man '$command_name' > '$command_name.txt'"; then
    # Check if the file is not empty
    if [ -s "$command_name.txt" ]; then
        # Notify user using osascript (AppleScript)
        osascript -e "display notification \"Converted ${command_name} page\" with title \"Man page converted\""
        echo "Man page for $command_name has been converted to $command_name.txt"
    else
        echo "Error: The converted file is empty. There might be an issue with the man page for $command_name."
        rm "$command_name.txt"
    fi
else
    echo "Error: Failed to convert man page for $command_name. The process timed out after 20 seconds."
    [ -f "$command_name.txt" ] && rm "$command_name.txt"
fi

echo "Script completed."
