#!/usr/bin/bash
#
# Show hyprland mappings

declare -a keys 
keys=(
  "Bring active window to top: ALT SHIFT, tab"
  "Change layout: \$mainMod, Space"
  "Change layout using menu: \$mainMod ALT, W"
  "Change wallpaper: \$mainMod, W"
  "Change waybar style: \$mainMod SHIFT, W"
  "Clipboard: \$mainMod ALT, V"
  "Cycle through windows: ALT, tab"
  "Display help information: \$mainMod, H"
  "Game mode: \$mainMod SHIFT, G"
  "Kill active window: \$mainMod, Q"
  "Kill active window: \$mainMod SHIFT, Q"
  "Kill hyprctl: \$mainMod, Escape"
  "Lock the screen: CTRL ALT, L"
  "Move active window down: \$mainMod CTRL, down"
  "Move active window down: \$mainMod CTRL, J"
  "Move active window left: \$mainMod CTRL, H"
  "Move active window left: \$mainMod CTRL, left"
  "Move active window right: \$mainMod CTRL, L"
  "Move active window right: \$mainMod CTRL, right"
  "Move active window silently to next workspace: \$mainMod SHIFT, bracketright"
  "Move active window silently to previous workspace: \$mainMod SHIFT, bracketleft"
  "Move active window silently to workspace n: \$mainMod SHIFT, number"
  "Move active window to next workspace: \$mainMod CTRL, bracketright"
  "Move active window to previous workspace: \$mainMod CTRL, bracketleft"
  "Move active window to workspace  n: \$mainMod CTRL, number"
  "Move active window up: \$mainMod CTRL, K"
  "Move active window up: \$mainMod CTRL, up"
  "Move focus down: \$mainMod, down"
  "Move focus left: \$mainMod, J"
  "Move focus left: \$mainMod, left"
  "Move focus right: \$mainMod, K"
  "Move focus right: \$mainMod, right"
  "Move focus up: \$mainMod, up"
  "Move to special workspace: \$mainMod SHIFT, U"
  "Reduce size of left screen: \$mainMod, M"
  "Reload configuration: \$mainMod SHIFT, C"
  "Resize active window down: \$mainMod SHIFT, down"
  "Resize active window down: \$mainMod SHIFT, J"
  "Resize active window left: \$mainMod SHIFT, H"
  "Resize active window left: \$mainMod SHIFT, left"
  "Resize active window right: \$mainMod SHIFT, L"
  "Resize active window right: \$mainMod SHIFT, right"
  "Resize active window up: \$mainMod SHIFT, K"
  "Resize active window up: \$mainMod SHIFT, up"
  "Scroll through workspaces: \$mainMod, comma"
  "Scroll through workspaces: \$mainMod, mouse_down"
  "Scroll through workspaces: \$mainMod, mouse_up"
  "Scroll through workspaces: \$mainMod, period"
  "Select wallpaper: \$mainMod CTRL, W"
  "Swap windows: \$mainMod CTRL, Return"
  "Switch to next workspace: \$mainMod, tab"
  "Switch to previous workspace: \$mainMod SHIFT"
  "Switch to workspace n: \$mainMod, number"
  "Take screenshot (10s delay): \$mainMod ALT, Print"
  "Take screenshot (5s delay): \$mainMod CTRL SHIFT, Print"
  "Take screenshot (area): \$mainMod SHIFT, Print"
  "Take screenshot (area with swappy): \$mainMod SHIFT, S"
  "Take screenshot (now): \$mainMod, Print"
  "Terminal emulator: \$mainMod, Return"
  "Thunar: \$mainMod, T"
  "Toggle floating mode: \$mainMod SHIFT, Space"
  "Toggle fullscreen mode: \$mainMod, F"
  "Toggle hide/show waybar: \$mainMod, B"
  "Toggle special workspace: \$mainMod, U"
  "Toggle window group: \$mainMod, G"
  "Wofi: \$mainMod, D"
  "WofiBeats: \$mainMod CTRL, S"
  "WofiBig: \$mainMod SHIFT, D"
  "WofiScripts: \$mainMod SHIFT, Z"
)

# Use dmenu to display the list of concepts and get user input

printf '%s\n' "${keys[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "hyprland mappings"

if command -v mako &>/dev/null; then
   notify-send "Expression $choice copied to clipboard." 
   echo "$choice" | wl-copy
else
    echo "mako not found, skipping notification."
fi



