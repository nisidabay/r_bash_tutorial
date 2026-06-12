#!/usr/bin/env bash
#
# Show dwm layouts in wofi

declare -a layouts
layouts=(
    "Floating mode >M>:Super+Shift+i"
    "Tile mode [ ]:Super+t"
    "Fibonacci [@]:Super+y"
    "Master left [D]:Super+u"
    "Master middle |M|:Super+i"
    "Master top TTT:Super+Shift+t"
)

# Use wofi --dmenu to display the list of shortcuts and get user input
choice=$(printf '%s\n' "${layouts[@]}" | rofi -dmenu -prompt "dwm available layouts")

if command -v rofi &>/dev/null; then
    notify-send "Expression $choice copied to clipboard."
    echo "$choice " | xclip -selection clipboard
else
    echo "rofi not found, skipping notification."
fi
