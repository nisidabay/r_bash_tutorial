#!/usr/bin/env bash

# Show and insert variable substitution templates in terminal
# Define test expressions concepts

declare -a loops

loops=(
    "while1: while ((\$z<=10));do z=\$((z+1));done"
    "while2: while [ "\$z" -lt 10 ];do z=\$((z+1));done"
    "while3: while true;do conditions;done"
    "for1: for ((i=1; i<=10; i++));do conditions;done"
    "for2: for i in {1..10};do conditions;done"
    "for3: for i in \$(seq 1 10);do conditions;done"
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${loops[@]}" | rofi -dmenu -p "Type of loops")

# Extract the regular expression from the user's choice
expression=$(echo "$choice" | awk -F ":" '{print $2}')

if command -v rofi &>/dev/null; then
    notify-send "Loop $expression copied to clipboard."
    echo "$expression" | xclip -r -selection clipboard
else
    echo "rofi not found, skipping notification."
fi
