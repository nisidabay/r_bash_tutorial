#!/usr/bin/bash
#
# Show dwm mappings in wofi

declare -a mappings
mappings=(
"All windows in a Gap:Ctrl+Super+number"
"Close Windows:Super+q"
"Full Screen:Super+f"
"Gaps Increase:Super+z"
"Gaps Restore:Super+A"
"Remove Gaps:Super+a"
"StrachPad:Super+Shift+Enter" 
"Toggle Menu Bar:Super+b" 
"Toggle Windows Focus:Super+j/k"
)


# Use wofi --dmenu to display the list of shortcuts and get user input
choice=$(printf '%s\n' "${mappings[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "dwm available layouts")

if command -v mako &>/dev/null; then
   notify-send "Expression $choice copied to clipboard." 
   echo "$choice" | wl-copy
else
    echo "mako not found, skipping notification."
fi

