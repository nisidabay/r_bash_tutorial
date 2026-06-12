#!/usr/bin/env bash
#
# A dmenu wrapper script for managing usbs
set -eou pipefail

BINARY_FILE=/home/nisidabay/bin/pyusb.py
declare -a operations
operations=("mount_all" "mount_one" "show_mounted" "show_plugged" "umount_all")

# Function to notify the user of the operation result
notify_user() {
    local message="$1"
    notify-send "USB Operation Result" "$message" \
        --icon=/usr/share/icons/AdwaitaLegacy/32x32/devices/media-removable.png
}

selection=$(printf '%s\n' "${operations[@]}" | rofi -dmenu -p "USBs management: ")

case "$selection" in
'mount_all')
    output=$(sudo "$BINARY_FILE" -m 2>&1)
    notify_user "$output"
    ;;
'mount_one')
    output=$(sudo "$BINARY_FILE" -o 2>&1)
    notify_user "$output"
    ;;
'show_mounted')
    output=$("$BINARY_FILE" -l 2>&1)
    notify_user "$output"
    ;;
'show_plugged')
    output=$("$BINARY_FILE" -p 2>&1)
    notify_user "$output"
    ;;
'umount_all')
    output=$(sudo "$BINARY_FILE" -u 2>&1)
    notify_user "$output"
    ;;
*) exit 1 ;;
esac
