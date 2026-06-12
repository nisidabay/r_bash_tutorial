#!/usr/bin/bash
#
# Copy emoji list from wofi

# Must have wl-clipboard installed

chosen=$(cat "$HOME/bin/dmenu/emoji" | wofi --dmenu --insensitive --lines 20 --prompt "Select an emoji")
[ -n "$chosen" ] || exit

# Get only the icon
icon=$(echo "$chosen" | awk '{print $1}')


if command -v mako &>/dev/null; then
   notify-send "Emoji copied $icon copied to clipboard." 
   echo "$icon" | tr -d '\n' | wl-copy
else
    echo "mako not found, skipping notification."
fi
    


