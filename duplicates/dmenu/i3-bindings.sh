#!/usr/bin/bash
#
# Show i3 bindings 

declare -a bindings
bindings=(
"Applications shortcuts:\$mod+F12"
"Change theme:\$mod+z"
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
"No borders:\$mod+Ctrl+u" 
"Normal borders:\$mod+Ctrl+n" 
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
"Thick borders:\$mod+Ctrl+y" 
"Toggle tiling | floating:\$mod+Shift+space"
)

# Use dmenu to display the list of i3 bindings
printf '%s\n' "${bindings[@]}" | dmenu -i -p "Available bindings:" -l 20 -fn Monospace-14 

