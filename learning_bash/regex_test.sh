#!/usr/bin/env BASH
#
# Process configuration array and skip comments

# Create a sample config.conf file
cat >config.conf <<EOF
# This is a comment
VAR1=Hello
VAR2=World

# Another comment
VAR3 = with spaces
var4
EOF

# Declare an associative array
declare -A config

# Read each line from the config file
while read -r line; do
  # Skip comments and empty lines
  # A comment line starts with a '#'
  [[ "$line" =~ ^[[:space:]]*# ]] && continue

  # Strip leading whitespace
  line="${line#"${line%%[![:space:]]*}"}"
  # Strip trailing whitespace
  line="${line%"${line##*[![:space:]]}"}"

  # Skip lines that are now empty after trimming
  [[ -z "$line" ]] && continue

  # Check if the line contains exactly one '=' sign
  if [[ "$line" =~ ^[^=]*=[^=]*$ ]]; then
    # Use IFS to split the line on the first '='
    IFS='=' read -r key value <<<"$line"

    # Trim leading/trailing whitespace from the key using pure BASH
    key="${key#"${key%%[![:space:]]*}"}"
    key="${key%"${key##*[![:space:]]}"}"

    # Trim leading/trailing whitespace from the value using pure BASH
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"

    # Check that both key and value are not empty
    if [[ -n "$key" && -n "$value" ]]; then
      config["$key"]="$value"
    fi
  fi
done <config.conf

if [[ ${#config[@]} -gt 0 ]]; then
  for key in "${!config[@]}"; do
    printf "%s=%s\n" "$key" "${config["$key"]}"
  done
fi

# Clean up the created file
rm config.conf
