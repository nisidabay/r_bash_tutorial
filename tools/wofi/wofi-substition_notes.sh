#!/usr/bin/bash
#
# Show and insert variable substitution templates in terminal
# Define regular expression concepts and their corresponding expressions
declare -a concepts

concepts=(
"File change extension: \${pattern%.cpp}.o" 
"File name: \${pattern##*/}"         
"File path: \${pattern%/*}"        
"File prefix substitution: \${pattern/#file/binary}"
"File subsitute extension: \${pattern/%cpp/sh}"
"File without extension: \${pattern%.ext}"        
"Lowercase 1st letter: \${str,}"
"Lowercase all letters: \${str,,}"
"Remove first slash: \${pattern#/}" 
"Slicing from the left: \${pattern:0:-1}" 
"Slicing from the left: \${pattern:0:2}" 
"Slicing from the left: \${pattern::-1}"
"Slicing from the left: \${pattern::2}"
"Slicing from the right: \${name:(-2):1}" 
"Slicing from the right: \${pattern:(-1)}" 
"String length: \${#var}"
"Substitution global: \${pattern//foo/bar}"
"Substitution: \${pattern/J/j}" 
"Uppercase 1st letter: \${str^}"   
"Uppercase all letters: \${str^^}"
"Var, otherwise value: \${Var:-value}"
"Var, otherwise value and Var=value: \${Var:=value}"
"Var, otherwise print value and exit: \${Var:?value}"
"Value if Var, otherwise use nothing: \${Var:+value}"
"Use length of Var: \${#var}"
"Use number of positional parameters: \${#*}"
"Use number of positional parameters: \${#@}"
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${concepts[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "Bash string substitution")

# Extract the regular expression from the user's choice
expression=$(echo "$choice" | awk -F ":" '{print $2}')

if command -v mako &>/dev/null; then
   notify-send "Expression $expression copied to clipboard." 
   echo "$expression" | wl-copy
else
    echo "mako not found, skipping notification."
fi
