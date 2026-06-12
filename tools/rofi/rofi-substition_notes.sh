#!/usr/bin/env bash
#
# Show and insert variable substitution templates in terminal
# Define regular expression concepts and their corresponding expressions
declare -a concepts

concepts=(
    "Change extension:\${pattern%.cpp}.o"
    "Length:\${#var}"
    "Lowercase 1st letter:\${str,}"
    "Lowercase all letters:\${str,,}"
    "Name:\${pattern##*/}"
    "Path:\${pattern%/*}"
    "Positional parameters:\${#*}"
    "Positional parameters:\${#@}"
    "R extension:\${pattern%.ext}"
    "Remove 1st slash:\${pattern#/}"
    "S Extension:\${pattern/%cpp/sh}"
    "S Prefix:\${pattern/#file/binary}"
    "S global:\${pattern//foo/bar}"
    "Slicing from left:\${pattern:0:-1}"
    "Slicing from left:\${pattern:0:2}"
    "Slicing from left:\${pattern::-1}"
    "Slicing from left:\${pattern::2}"
    "Slicing from right:\${name:(-2):1}"
    "Slicing from right:\${pattern:(-1)}"
    "Substitution:\${pattern/J/j}"
    "Uppercase 1st letter:\${str^}"
    "Uppercase all letters:\${str^^}"
    "Value if Var, or nothing:\${Var:+value}"
    "Var, or assign:\${Var:=value}"
    "Var, or value, exit:\${Var:?value}"
    "Var, or value:\${Var:-value}"
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${concepts[@]}" | rofi -dmenu -p "Bash string substitution")

# Extract the regular expression from the user's choice
expression=$(echo "$choice" | awk -F ":" '{print $2}')

notify-send "Expression $expression copied to clipboard."
echo "$expression" | xclip -r -selection clipboard
