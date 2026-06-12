#!/usr/bin/bash
#
# Show i3-bindings

declare -a bindings
bindings=(
    "Enter full screen:\$mod+f"
    "Exit menu:\$mod+Shift+e"
    "Exit resize mode:Escape"
    "Focus down:\$mod+i"
    "Focus left:\$mod+j"
    "Focus parent container:\$mod+a"
    "Focus right:\$mod+k"
    "Focus up:\$mod+u"
    "Kill windows:\$mod+c"
    "Layout - stack:\$mod+s"
    "Layout - tabbed:\$mod+g"
    "Layout - toggle split:\$mod+e"
    "Light boders:\$mod+Ctrl+y"
    "Move thru tiling | floating windows:\$mod+space"
    "Move to scratchpad:\$mod+Shift+minus"
    "Move windows down:\$mod+Shift+i"
    "Move windows left:\$mod+Shift+j"
    "Move windows right:\$mod+Shift+k"
    "Move windows up:\$mod+Shift+u"
    "No borders:\$mod+Ctrl+u"
    "Open empty workspace:\$mod+Shift+n"
    "Reload config:\$mod+Shift+c"
    "Resize mode:\$mod+r"
    "Restart i3:\$mod+Shift+r"
    "Rofi:\$mod+d"
    "Screenlock:\$mod+l"
    "Show scratchpad:\$mod+minus"
    "Split window horizontally:\$mod+v"
    "Split window vertically:\$mod+h"
    "Terminal:\$mod+Return"
    "Thick boders:\$mod+Ctrl+n"
    "Toggle tiling | floating:\$mod+Shift+space"
    "calendar:\$mod+Shift+z"
    "dmenu:\$mod+Shift+d"
    "firefox:\$mod+w"
    "neomutt:\$mod+m"
    "snapshot: F12"
    "st:\$mod+Shift+p"
    "thunar:\$mod+n"
    "vim:\$mod+p"
)

if command -v wofi &>/dev/null && command -v wl-copy &>/dev/null; then
    # Use wofi --dmenu to display the list of shortcuts and get user input
    choice=$(printf '%s\n' "${bindings[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "i3-bindings")
    notify-send "Expression $choice copied to clipboard."
    echo "$choice" | wl-copy
fi

if command -v dmenu &>/dev/null && command -v xclip; then
    choice=$(printf '%s\n' "${bindings[@]}" | dmenu -i -l 20 -p "i3-bindings")
    echo "$choice" | xclip -r -selection clipboard
    notify-send "Expression $choice copied to clipboard."
fi
