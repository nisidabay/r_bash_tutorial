#!/usr/bin/env bash
#
# Copy emoji list from rofi

chosen=$(cat "$HOME/bin/dmenu/emoji_list" | rofi -dmenu -p "Select an emoji")
[ -n "$chosen" ] || exit

# Get only the icon
icon=$(echo "$chosen" | awk '{print $1}')

if command -v rofi &>/dev/null; then
    notify-send "Emoji copied $icon copied to clipboard."
    echo "$icon" | tr -d '\n' | xclip -selection clipboard
else
    echo "rofi not found, skipping notification."
fi
