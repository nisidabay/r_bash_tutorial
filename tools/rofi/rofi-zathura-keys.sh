#!/usr/bin/env bash
#
# Show zathura main keys

declare -a keys

keys=(
    "Abort the current action: C-g"
    "Bottom of document: G"
    "Dark mode: Ctrl+r"
    "Go to page <number>: :<number><enter>"
    "Go to the first page: gg"
    "Go to the last page: G"
    "Highlight URLS to follow: f"
    "Move in document: h/j/k/l"
    "Print document: p"
    "Quit zathura: q"
    "Reload document if changed: r"
    "Reload the document: r"
    "Rotate document: R"
    "Rotate 90 degrees clockwise: R"
    "Scroll down: j"
    "Scroll half page down: d"
    "Scroll half page up: u"
    "Scroll left: h"
    "Scroll one page down: C-d"
    "Scroll one page up: C-u"
    "Scroll right: l"
    "Scroll up: k"
    "Toggle dual-page mode: D"
    "Toggle presentation mode: s"
    "Top of document: gg"
    "Zoom out/in: zi/zo/z0"
)

# Use dmenu to display the list of concepts and get user input
printf '%s\n' "${keys[@]}" | rofi -dmenu -p "Zathura keys"
