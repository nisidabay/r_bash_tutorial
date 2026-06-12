#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Fake User Data Generator
#
# This script generates a specified number of fake user data entries, each
# consisting of a random name, age, and email address. It demonstrates the
# use of `/dev/urandom`, `tr`, `head`, and the `$RANDOM` variable for data
# generation.
#
# It also showcases a powerful and efficient way to populate a Bash array
# using a loop, process substitution (`< <(...)`), and the `mapfile` command.
#
# Usage:
#   ./generate_fake_data.sh [number_of_users]
#
# If `number_of_users` is not provided, it defaults to 5.
# ==============================================================================

# --- Functions ---

# Generates a single line of fake user data.
# Output format: "Name,Age,Email"
generate_fake_user() {
    local name age email

    # Generate a random 5-character alphabetic name.
    # `LC_ALL=C` ensures consistent behavior of `tr` across different locales.
    # `tr -dc 'a-zA-Z'` deletes all characters that are NOT alphabetic.
    name=$(LC_ALL=C tr -dc 'a-zA-Z' </dev/urandom | head -c 5)

    # Generate a random age between 20 and 79.
    age=$((RANDOM % 60 + 20))

    # Create an email address from the lowercase version of the name.
    email="${name,,}@example.com"

    echo "$name,$age,$email"
}

# --- Main Logic ---
main() {
    local num_users="${1:-5}" # Default to 5 users if no argument is given.

    # Validate input
    if ! [[ "$num_users" =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: Please provide a positive integer for the number of users." >&2
        exit 1
    fi

    echo "Generating $num_users fake users..."

    # Use `mapfile` (also known as `readarray`) to read the output of a process
    # directly into an array. Each line of output becomes an element in the array.
    # This is more efficient than a `while read` loop for this purpose.
    local -a data_rows
    mapfile -t data_rows < <(
        for ((i = 1; i <= num_users; i++)); do
            generate_fake_user
        done
    )

    echo "--- Generated Data ---"
    echo "Created ${#data_rows[@]} users:"

    # Safely print each element of the array.
    printf "%s\n" "${data_rows[@]}"
    echo "----------------------"
}

# --- Script Entry Point ---
main "$@"
