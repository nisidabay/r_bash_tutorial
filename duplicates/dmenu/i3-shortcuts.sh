#!/usr/bin/bash
#
# i3 applications shortcut

# Define an array of shortcuts and corresponding commands
shortcuts=(
    "Cmus: \$mod + x"
    "Firefox: \$mod + w"
    "Opera: \$mod + o"
    "Snapshot: F12"
    "Terminal: \$mod + Enter"
    "Thunar: \$mod + n"
    "Tor: \$mod + Shift + t"
    "Vifm: \$mod + Up"
    "Vim: \$mod + Shift + v"
)

# Use dmenu to display the list of shortcuts and get user input
printf '%s\n' "${shortcuts[@]}" | dmenu -i -l 20 -fn Monospace-14 -p "i3 applications shortcut:"

