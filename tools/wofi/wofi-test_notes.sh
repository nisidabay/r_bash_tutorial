#!/usr/bin/bash
# Show and insert variable substitution templates in terminal
# Define test expressions concepts 

declare -a concepts

concepts=(
"test: test 15 -eq 15 && echo Yes"
"globing: [[ \$stringvar == *elk* ]]"
"comparison: [[ \$stringvar == *[cC]lam* ]]"
"comparison: [[ \$stringvar == \$surname ]]"
"comparison: [[ \$first -eq 10 && \$second -lt 26 ]]"
"comparison: [[ \$first -gt 15 || \$second -lt 26 ]]"
"regexp: [[ \$words =~ \$pattern ]]"
"arithmetic: \$(( number > 10 ))"
"arithmetic: test [ "\$number" -gt 10 ]"
"arithmetic: [[ \$number -gt 10 ]]"
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${concepts[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "Bash test command")

# Extract the regular expression from the user's choice
expression=$(echo "$choice" | awk -F ":" '{print $2}')

if command -v mako &>/dev/null; then
   notify-send "Expression $expression copied to clipboard." 
   echo "$expression" | wl-copy
else
    echo "mako not found, skipping notification."
fi

