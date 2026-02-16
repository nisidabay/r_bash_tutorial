#!/usr/bin/env BASH
#
# Handles input from file or pipe

# Check if input is from a file
if [ -s "$1" ]; then
  # Input is from a file, cat the contents
  content=$(cat "$1")
else
  # Input is from a pipe, read it line by line
  while IFS= read -r line; do
    echo "$line"
  done <&0
fi

# Use the input as needed
echo "Input contains:"
echo "$content"
