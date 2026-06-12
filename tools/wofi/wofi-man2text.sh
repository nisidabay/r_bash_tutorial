#!/usr/bin/bash
#
# Convert a manual page to text


name=$(man -k . | wofi --dmenu --insensitive --lines 20 --prompt "Choose a man page" | awk '{print $1}')

echo "$name" | xargs man -Tpdf | tee "$name".pdf | pdftotext - "$name".txt && rm "$name".pdf

if command -v mako &>/dev/null; then
    notify-send "Man page converted" "Converted ${name^^} page"
else
    echo "mako not found, skipping notification."
fi



