#!/usr/bin/bash

# Show and insert variable substitution templates in terminal
# Define test expressions concepts 

declare -a concepts

loops=(
"while1: while ((\$z<=10));do z=\$((z+1));done"
"while2: while [ "\$z" -lt 10 ];do z=\$((z+1));done"
"while3: while true;do conditions;done"
"for1: for ((i=1; i<=10; i++));do conditions;done" 
"for2: for i in {1..10};do conditions;done" 
"for3: for i in \$(seq 1 10);do conditions;done" 
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${loops[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "Type of loops")

# Extract the regular expression from the user's choice
expression=$(echo "$choice" | awk -F ":" '{print $2}')

if command -v mako &>/dev/null; then
   notify-send "Loop $expression copied to clipboard." 
   echo "$expression" | wl-copy
else
    echo "mako not found, skipping notification."
fi

