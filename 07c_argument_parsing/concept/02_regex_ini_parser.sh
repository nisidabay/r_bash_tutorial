#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Robust INI/Config File Parser in Pure Bash
#
# This script demonstrates how to parse a simple `.conf` or `.ini` style file
# into a Bash associative array. It is designed to be robust against common
# formatting inconsistencies.
#
# Features:
# - Skips empty lines and lines that are comments (start with '#').
# - Trims leading and trailing whitespace from lines, keys, and values.
# - Safely handles keys and values that contain spaces.
# - Uses an associative array (Bash 4.0+) for a clean key-value store.
# - Validates that a line contains a valid key=value pair.
#
# This is a pure Bash solution and does not rely on external tools like `sed`
# or `awk` for parsing.
# ==============================================================================

# --- Main Logic ---
main() {
    local config_file="config.conf"

    # --- Setup: Create a sample config file for the demo ---
    cat >"$config_file" <<EOF
# This is a comment line.
VAR1=Hello
VAR2=World

# Another comment
VAR3 = with spaces around equals
  VAR4 = value with leading space
VAR5=value with trailing space
var6 # Invalid line without equals
VAR7==Invalid
VAR8=
=Invalid
EOF

    # --- Parsing Logic ---

    # Declare an associative array to hold the configuration.
    # Requires Bash 4.0 or newer.
    declare -A config

    echo "--- Parsing '$config_file' ---"

    # Read the file line by line.
    while IFS= read -r line; do
        # 1. Skip comments and empty lines using a regex.
        # `^`: Asserts position at the start of the string.
        # `[[:space:]]*`: Matches zero or more whitespace characters.
        # `#`: Matches the literal character '#'.
        if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$line" ]]; then
            continue
        fi

        # 2. Check if the line looks like a valid "key=value" pair.
        # `^[^=]+`: Starts with one or more characters that are not '='.
        # `=`: Followed by a literal '='.
        # `.*`: Followed by any character, any number of times.
        if [[ "$line" =~ ^[^=]+=.*$ ]]; then
            # 3. Split the line into key and value at the first '='.
            local key="${line%%=*}"
            local value="${line#*=}"

            # 4. Trim whitespace from the key.
            # Remove leading whitespace
            key="${key#"${key%%[![:space:]]*}"}"
            # Remove trailing whitespace
            key="${key%"${key##*[![:space:]]}"}"

            # 5. Trim whitespace from the value.
            value="${value#"${value%%[![:space:]]*}"}"
            value="${value%"${value##*[![:space:]]}"}"

            # 6. Store in the associative array if the key is not empty.
            if [[ -n "$key" ]]; then
                config["$key"]="$value"
                echo "Loaded: [$key] = [$value]"
            fi
        else
            echo "Skipping malformed line: '$line'"
        fi
    done <"$config_file"

    echo "--- Parsing Complete ---"

    # --- Display Results ---
    if ((${#config[@]} > 0)); then
        echo "Found ${#config[@]} valid configuration entries:"
        for key in "${!config[@]}"; do
            printf "  '%s' is set to '%s'\n" "$key" "${config[$key]}"
        done
    else
        echo "No valid configuration entries were found."
    fi

    # --- Cleanup ---
    rm -f "$config_file"
    echo "--- Cleaned up temporary config file ---"
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
