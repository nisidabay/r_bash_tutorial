#!/usr/bin/bash
#
# Show tput colors table

declare -a colors

colors=(
    "Black: tput setaf 0"
    "Red: tput setaf 1"
    "Green: tput setaf 2"
    "Yellow: tput setaf 3"
    "Blue: tput setaf 4"
    "Magenta: tput setaf 5"
    "Cyan: tput setaf 6"
    "White: tput setaf 7"
    "Bright Black (Gray): tput setaf 8"
    "Bright Red: tput setaf 9"
    "Bright Green: tput setaf 10"
    "Bright Yellow: tput setaf 11"
    "Bright Blue: tput setaf 12"
    "Bright Magenta: tput setaf 13"
    "Bright Cyan: tput setaf 14"
    "Bright White: tput setaf 15"
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${colors[@]}" | rofi -dmenu -p "Choose a color:")

color=$(echo "$choice" | awk -F ":" '{print $2}')

# Copy to clipboard
echo "$color" | xclip -selection clipboard
notify-send "$color copied to clipboard." &
