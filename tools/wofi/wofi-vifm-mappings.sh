#!/usr/bin/bash
#
# Show vifmrc main keys

declare -a keys 
keys=(
  "Change and clear line: cc"
  "Close view: <c-wz>"
  "Copy selected file(s): <F5>"
  "Create a new directory: <F7>"
  "Delete selected file(s): <F8>"
  "Display sorting dialog: S"
  "Dual pane: <Ctrlw-Ctrlv>"
  "Edit file: <f4>"
  "Move selected file(s): <F6>"
  "Open console in current directory: ,t"
  "Open current directory in the other pane: <a-i>"
  "Open directory under cursor in the other pane: <a-o>"
  "Open editor to edit vifmrc and apply settings after returning to vifm: ,c"
  "Open file in the background using its default program: gb"
  "Single pane: <Ctrlw-Ctrlo>"
  "Change filename insert at the beginning of the line: I"
  "Change filename insert mode at the end of the line: A"
  "Start shell in current directory: s"
  "Swap panes: <c-u>"
  "Swap panes: <c-wx>"
  "Toggle visibility of preview window: w"
  "Toggle wrap setting on ,w key: ,w"
  "View file with less: <F3>"
  "View all maps: nmap"
  "Yank current directory path into the clipboard: yd"
  "Yank current file path into the clipboard: yf"
)
# Use dmenu to display the list of concepts and get user input

choice=$(printf '%s\n' "${keys[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "vifm mappings")

if command -v mako &>/dev/null; then
   notify-send "Expression $choice copied to clipboard." 
   echo "$choice" | wl-copy
else
    echo "mako not found, skipping notification."
fi



