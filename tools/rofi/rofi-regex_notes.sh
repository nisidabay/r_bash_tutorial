#!/usr/bin/env bash
#
# Show and insert regular expressions in the terminal

# Define regular expression concepts and their corresponding expressions
declare -a concepts
concepts=(
    "All letters and numbers: [0-9a-zA-Z]"
    "All letters and numbers: [[:alnum:]]"
    "All letters: [[:alpha:]]"
    "All letters: [a-zA-Z]"
    "Any character (wildcard): ."
    "Backreference: \\1"
    "Digits 0 to 9: [0-9]"
    "Digits 0 to 9: [[:digit:]]"
    "Grouping: ()"
    "Hexadecimal digits: [0-9a-fA-F]"
    "Hexadecimal digits: [[:xdigit:]]"
    "Lowercase letters: [[:lower:]]"
    "Lowercase letters: [a-z]"
    "Match any character in range: -"
    "Match any except these characters: [^]"
    "Match any of these characters: []"
    "Match end of line/string: $"
    "Match start of line/string: ^"
    "One or more: +"
    "Punctuation and other characters: [[:punct:]]"
    "Punctuation and other characters: [^a-zA-Z0-9]"
    "Spaces and tabs: [[:blank:]]"
    "Uppercase letters: [A-Z]"
    "Uppercase letters: [[:upper:]]"
    "Zero or more: *"
    "Zero or one (optional): ?"
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${concepts[@]}" | rofi -dmenu -p "Choose a regexp to insert:")

# Extract the regular expression from the user's choice
echo "$choice" | awk -F ": " '{print $2}' | xclip -r -selection clipboard
notify-send "Expression $choice copied to clipboard."
