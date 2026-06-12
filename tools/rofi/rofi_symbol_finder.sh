#!/usr/bin/env bash
#
# This script uses rofi to select a symbol from a list and copies it to the
# clipboard.

# Insert greek letters

DIRNAME=$HOME/bin
SYMBOL_LIST_FILE="$DIRNAME/symbol-list.txt"

# Check if the symbol list file exists.
if [ ! -f "$SYMBOL_LIST_FILE" ]; then
    echo "Symbol list file not found at $SYMBOL_LIST_FILE"
    exit 1
fi

# Check if rofi and xclip are installed.
if ! command -v rofi &>/dev/null; then
    echo "rofi could not be found, please install rofi."
    exit 1
fi

if ! command -v xclip &>/dev/null; then
    echo "xclip could not be found, please install xclip."
    exit
fi

symbol=$(rofi -dmenu -i -p "Choose a symbol" <"$SYMBOL_LIST_FILE" | cut -f 1)

# Now, copy the selected symbol to the clipboard using xclip.
echo "$symbol" | xclip -selection clipboard

# Notify the user that the symbol has been copied.
if [ -n "$symbol" ]; then
    notify-send "Symbol copied" "$symbol"
else
    notify-send "No symbol selected" "No symbol was copied to the clipboard."
fi
