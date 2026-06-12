#!/usr/bin/env bash
#
# Script to open bookmarks in a browser

SCRIPT_PATH="$HOME/bin"

BROWSER=${BROWSER:-"firefox"}
BOOKMARKS_FILE="$SCRIPT_PATH/bookmarks.txt"

# Function to handle errors
handle_error() {
    echo "An error occurred. Check the bookmarks file"
    exit 1
}

# Set a trap to catch errors
trap handle_error ERR

# Check for dependencies
if ! command -v rofi >/dev/null; then
    echo "rofi is not installed. Please install rofi."
    exit 1
fi

if ! command -v "$BROWSER" >/dev/null; then
    echo "$BROWSER is not installed. Please install $BROWSER."
    exit 1
fi

# Check if the bookmarks file exists
if [[ -f "$BOOKMARKS_FILE" ]]; then
    # Use dmenu to filter bookmarks and select an address
    ADDRESS=$(rofi -dmenu -p "Selected a bookmark: " <"$BOOKMARKS_FILE" | cut -d'-' -f2-)

    if [[ -n "$ADDRESS" ]]; then
        "$BROWSER" "$ADDRESS"
    else
        echo "No bookmark selected."
    fi
else
    echo "Bookmarks file not found at $BOOKMARKS_FILE."
fi
