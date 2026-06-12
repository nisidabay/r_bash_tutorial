#!/usr/bin/bash
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

choice=$(printf '%s\n' "${keys[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "st terminal keys")
    
if command -v mako &>/dev/null; then
   notify-send "st  $choice  copied to clipboard." 
   echo "$choice" | wl-copy
else
    echo "mako not found, skipping notification."
fi


