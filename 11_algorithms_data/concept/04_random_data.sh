#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Bash Random Data Generation Examples
#
# This script is a collection of functions demonstrating various techniques for
# generating random data in Bash, from simple numbers to more complex strings,
# dates, and passwords.
#
# It primarily uses the built-in `$RANDOM` variable and the `/dev/urandom` device.
#
# - `$RANDOM`: A Bash-specific variable that returns a pseudo-random integer
#   between 0 and 32767 each time it is referenced.
# - `/dev/urandom`: A special file in Unix-like systems that provides a stream
#   of cryptographically secure pseudo-random bytes.
# ==============================================================================

# --- Functions ---

# Demonstrates basic usage of the $RANDOM variable.
generate_basic_random_number() {
    echo "--- Basic Usage ---"
    local random_number=$RANDOM
    echo "A random integer between 0 and 32767: $random_number"
}

# Generates a random number within a specific range using the modulo operator.
generate_random_number_in_range() {
    echo "--- Random Number in a Range (e.g., 1-100) ---"
    # `RANDOM % 100` gives a number from 0-99. Add 1 to get 1-100.
    local random_number=$((RANDOM % 100 + 1))
    echo "Random number between 1 and 100: $random_number"
}

# Simulates rolling a standard six-sided die.
simulate_dice_roll() {
    echo "--- Simulating a Dice Roll ---"
    local dice_roll=$((RANDOM % 6 + 1))
    echo "You rolled a: $dice_roll"
}

# Selects a random element from a Bash array.
select_random_option_from_list() {
    echo "--- Random Selection from a List ---"
    local options=("apple" "banana" "cherry" "dragonfruit")
    # `${#options[@]}` gets the total number of elements in the array.
    local random_index=$((RANDOM % ${#options[@]}))
    local random_option=${options[$random_index]}
    echo "Randomly selected fruit: $random_option"
}

# Generates a unique filename using a timestamp and a random number.
generate_random_file_name() {
    echo "--- Random File Name Generation ---"
    # `date +%s` provides the current Unix timestamp for uniqueness.
    local file_name
    file_name="data_$(date +%s)_$RANDOM.txt"
    echo "Generated file name: $file_name"
}

# Generates a more secure random password using `/dev/urandom`.
generate_random_password() {
    echo "--- Random Password Generation ---"
    # Read from /dev/urandom, delete all non-alphanumeric characters,
    # and take the first 12 bytes.
    local password
    password=$(</dev/urandom tr -dc 'A-Za-z0-9' | head -c12)
    echo "Generated 12-character password: $password"
}

# Generates a random, syntactically valid (but not necessarily real) IP address.
generate_random_ip_address() {
    echo "--- Random IP Address Generation ---"
    local ip_address="$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
    echo "Generated IP address: $ip_address"
}

# Generates a random hex color code.
generate_random_color_hex() {
    echo "--- Random Hex Color Code ---"
    # `%06X` formats a number as a 6-digit, zero-padded, uppercase hexadecimal.
    local color
    color=$(printf '#%06X' "$((RANDOM * RANDOM))")
    echo "Random color (hex): $color"
}

# Generates a random date between two given dates.
generate_random_date_between_two_dates() {
    echo "--- Random Date Between Two Dates ---"
    local start_date="2023-01-01"
    local end_date="2023-12-31"

    # Convert start and end dates to Unix timestamps (seconds since epoch).
    local start_timestamp
    start_timestamp=$(date -ud "$start_date" +%s)
    local end_timestamp
    end_timestamp=$(date -ud "$end_date" +%s)

    # Calculate the range of seconds between the two dates.
    local seconds_range=$((end_timestamp - start_timestamp))
    # Generate a random number of seconds within that range.
    local random_seconds=$((RANDOM % seconds_range))

    # Add the random seconds to the start timestamp to get a new random timestamp.
    local random_timestamp=$((start_timestamp + random_seconds))

    # Convert the random timestamp back to a human-readable date format.
    local random_date
    random_date=$(date -ud "@$random_timestamp" +"%Y-%m-%d")

    echo "Random date between $start_date and $end_date: $random_date"
}

# Generates a random alphanumeric string of a specific length.
generate_random_alphanumeric_string() {
    echo "--- Random Alphanumeric String ---"
    local length=10
    local random_string
    random_string=$(</dev/urandom tr -dc 'A-Za-z0-9' | head -c"$length")
    echo "Generated ${length}-character string: $random_string"
}

# --- Main Execution ---
main() {
    local functions=(
        "generate_basic_random_number"
        "generate_random_number_in_range"
        "simulate_dice_roll"
        "select_random_option_from_list"
        "generate_random_file_name"
        "generate_random_password"
        "generate_random_ip_address"
        "generate_random_color_hex"
        "generate_random_date_between_two_dates"
        "generate_random_alphanumeric_string"
    )

    if [[ $# -gt 0 && "$1" == "all" ]]; then
        # If the first argument is "all", run all functions.
        for func in "${functions[@]}"; do
            "$func"
            echo
        done
    else
        # Otherwise, show a menu to select a function.
        PS3="Select a random generator to run (or 'q' to quit): "
        select choice in "${functions[@]}"; do
            if [[ -n "$choice" ]]; then
                "$choice"
                break
            else
                echo "Invalid choice. Please try again."
            fi
        done
    fi
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
