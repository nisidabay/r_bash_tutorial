#!/usr/bin/bash
#
# Show vifmrc main keys

declare -a keys 
keys=(
    "App launcher: Super + d"
    "Change and clear line: cc"
    "Change focus {west, south, north, east}: Super + {h, j, k, l}"
    "Close focused window: Super + Shift + q"
    "Contract a window {left, bottom, top, right}: Super + Alt + Shift + {h, j, k, l}"
    "Expand a window {left, bottom, top, right}: Super + Alt + {h, j, k, l}"
    "Focus newer node in focus history: Super + i"
    "Focus older node in focus history: Super + o"
    "Focus the last desktop: Super + Tab"
    "Focus the last node: Super + grave"
    "Launch Firefox: Super + w"
    "Launch Thunar: Super + e/n"
    "Move a floating window: Super + {left, down, up, right}"
    "Open terminal: Super + Return"
    "Power Menu: Super + Shift + e"
    "Quit Bspwm: Super + Alt + q"
    "Reload Sxhkd: Super + Escape"
    "Restart Bspwm: Super + Alt + r"
    "Screen shot: Print"
    "Send current node to different desktop: Super + Shift + <number>"
    "Show SSH sessions: Super + Shift + d"
    "Show screenshot men: Super + Print"
    "Swap current and largest window: Super + g"
    "Switch between tiled and monocle layout: Super + m"
    "Switch to different desktop: Super + <number>"
    "Window switcher: Super + Ctrl + d"
)

# Use wofi --dmenu to display the list of shortcuts and get user input
choice=$(printf '%s\n' "${keys[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "bspwm keys")


if command -v mako &>/dev/null; then
   notify-send "Expression $choice copied to clipboard." 
   echo "$choice" | wl-copy
else
    echo "mako not found, skipping notification."
fi

