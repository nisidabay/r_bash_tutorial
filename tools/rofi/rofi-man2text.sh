#!/usr/bin/env bash
#
# Convert a manual page to text

name=$(man -k . | rofi -dmenu -p "Man page to text" | awk '{print $1}')

echo "$name" | xargs man -Tpdf | tee "$name".pdf | pdftotext - "$name".txt && rm "$name".pdf

if command -v rofi &>/dev/null; then
    notify-send "Man page converted" "Converted ${name^^} page"
else
    echo "rofi not found, skipping notification."
fi
