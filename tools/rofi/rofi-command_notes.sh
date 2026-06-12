#!/usr/bin/env bash
# Show and insert shell command forms templates in terminal
# Define shell command forms commands

declare -a commands
commands=(
    "Commands sequence:cmd1 ; cmd2"
    "Execute cmd and change the exit status:! cmd "
    "Execute cmd in background:cmd &"
    "Execute cmd1 and then (if cmd2 succeeds):cmd1 && cmd2"
    "Execute commands as a group in a subshell:(cmd1 ; cmd2)"
    "Execute commands as a group in the current shell:{ cmd1 ; cmd2 ; }"
    "Execute either cmd1 or (if cmd1 fails) cmd2:cmd1 || cmd2"
    "POSIX shell arithmetic substitution:cmd \$((expression))"
    "POSIX shell command substitution:cmd1 \$(cmd2)"
    "Use output from cmd1 as input to cmd2:cmd1 | cmd2"
)

# Use wofi dmenu to display the list of commands and get user input
choice=$(printf '%s\n' "${commands[@]}" | rofi -dmenu -p "Bash command notes:" "$@")
# Extract the regular expression from the user's choice
expression=$(echo "$choice" | awk -F ":" '{print $2}') 2>/dev/null

if command -v rofi &>/dev/null; then
    notify-send "Expression $expression copied to clipboard."
    echo "$expression" | xclip -r -selection clipboard
else
    echo "rofi not found, skipping notification."
fi
