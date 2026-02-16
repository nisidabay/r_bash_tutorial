#!/usr/bin/env BASH
#
# Create a temporary file
set -eu

tmpfile="$(mktemp)"

# Clean up the temporary directory on exit
trap 'rm -rf "$tmpfile"' EXIT

cat <<EOF >"$tmpfile"
This is a temp file
EOF

# Use nvim to open the file in the temporary directory
cat "$tmpfile"

echo "Deleted: $tmpfile" >&2
