#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# This script demonstrates how to create and use a temporary file in bash.

# Create a temporary file
tmpfile="$(mktemp)"

# Clean up the temporary directory on exit
# The 'trap' command ensures that the temporary file is deleted when the script
# exits, even if it exits with an error.
trap 'rm -f "$tmpfile"' EXIT

# Write some content to the temporary file
cat <<EOF >"$tmpfile"
This is a temp file
EOF

# Display the content of the temporary file
cat "$tmpfile"

# Print the path of the deleted temporary file
echo "Deleted: $tmpfile"
