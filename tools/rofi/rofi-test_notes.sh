#!/usr/bin/env bash
#
# Show and insert variable substitution templates in terminal

# Declare an array to hold test expressions concepts
declare -a concepts
# Initialize the array with various test expressions
concepts=(
    "test:test 15 -eq 15 && echo Yes"
    "globing:[[ \$stringvar == *elk* ]]"
    "comparison:[[ \$stringvar == *[cC]lam* ]]"
    "comparison:[[ \$stringvar == \$surname ]]"
    "comparison:[[ \$first -eq 10 && \$second -lt 26 ]]"
    "comparison:[[ \$first -gt 15 || \$second -lt 26 ]]"
    "comparison:[[ \$SIZE =~ ^[0-9]+$ ]] && [ \$SIZE -ge 1 ] && [ \$SIZE -le 1000 ]"
    "regexp:[[ \$words =~ \$pattern ]]"
    "arithmetic:\$(( number > 10 ))"
    "arithmetic:test [ \$number -gt 10 ]"
    "arithmetic:[[ \$number -gt 10 ]]t 15 -eq 15 && echo Yes"
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${concepts[@]}" | rofi -dmenu -p "Choose a test expression:")

# Check if the user made a selection
if [[ -n "$choice" ]]; then
    # Extract the regular expression from the user's choice
    echo "$choice" | awk -F ":" '{print $2}' | xclip -r -selection clipboard
    notify-send "Expression $choice copied to clipboard."
fi
