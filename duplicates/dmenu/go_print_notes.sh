#!/usr/bin/bash
# Show and copy to clipboard go print formatters
# Define test expressions concepts 

declare -a concepts

concepts=(
"%d: decimal integer"
"%x: integer in hexadecimal"
"%o: octal "
"%b: binary"
"%f: floating-point number"
"%g: floating-point number"
"%e: floating-point number"
"%t: true or false"
"%c: rune (Unicode code point)"
"%s: string"
"%q: quoted string "abc" or rune 'c'"
"%v: any value in a natural format"
"%T: type of any value"
"%%: literal percent sign (no operand)"
)


# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${concepts[@]}" | dmenu -i -p "Choose a go print format to insert:" -l 20 -fn Monospace-14 )

# Extract the regular expression from the user's choice
expression=$(echo "$choice" | awk -F ":" '{print $1}')

echo "$expression" | tr -d '\n' | xclip -selection clipboard
notify-send "'$expression' copied to clipboard." &

