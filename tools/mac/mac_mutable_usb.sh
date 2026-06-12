#!/usr/bin/env bash
#
# Make USB contents writable on macOS

# Checks if the programs passed as strings are installed
chk_dependencies() {
    local -a dependencies_array=($@)
    local -a missing=()
    for program in "${dependencies_array[@]}"; do
        if ! command -v "$program" >/dev/null; then
            missing+=("$program")
        fi
d    done
    if [[ "${#missing[@]}" -gt 0 ]]; then
        local missing_programs="${missing[*]}"
        echo "Install the missing dependencies before continuing: $missing_programs"
        osascript -e "display notification \"Install the following programs before continuing: $missing_programs\" with title \"Missing Dependencies\""
        exit 1
    fi
}

# Execution starts HERE
chk_dependencies "find" "sudo" "chflags" "osascript"


# Prompt the user for the path to the USB drive
read -p "Enter the path to your USB drive: " -r usb_path

# Check if the provided path is not empty
if [[ -z "$usb_path" ]]; then
    echo "No path entered. Exiting the script."
    exit 1
fi

# Check if the provided path exists
if [[ ! -d "$usb_path" ]]; then
    echo "The provided path does not exist. Exiting the script."
    exit 1
fi

# Removing the user immutable attribute from all files and directories in the specified path
echo "Removing the user immutable attributes from all contents in $usb_path"
find "$usb_path" -type f -exec sudo chflags nouchg {} \;
find "$usb_path" -type d -exec sudo chflags nouchg {} \;

echo "Operation completed."
osascript -e 'display notification "Operation completed." with title "USB Mutability"'
