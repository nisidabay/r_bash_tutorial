#!/usr/bin/env bash
#
# Show st-gerry main keys
declare -a keys
keys=(
    "Capture and Edit Screen: Alt+e"
    "Copy Clipboard: Ctrl+Shift+C"
    "Copy Command Output: Alt+o"
    "Copy URL: Alt+y"
    "Open Terminal in the same path: Ctr+Shift+Return"
    "Open URL: Alt+i"
    "Paste Command Output: Ctr+Shift+Y"
    "Paste Clipboard: Ctr+Shiff+V"
)

# Use dmenu to display the list of st-gerry keys
printf '%s\n' "${keys[@]}" | rofi -dmenu -p "st-gerry keys" | xclip -selection clipboard
notify-send "st-gerry keys copied to clipboard"
