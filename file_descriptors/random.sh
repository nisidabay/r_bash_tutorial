#!/usr/bin/env bash

#
# BASH RANDOM Function Usage Examples

# Function to demonstrate basic random number generation
generate_basic_random_number() {
    echo "=== Basic Usage ==="
    local random_number=$RANDOM
    echo "Random number: $random_number"
    echo
}

# Function to generate a random number between 1 and 100
generate_random_number_between_1_and_100() {
    echo "=== Random Number Between 1 and 100 ==="
    local random_number=$((RANDOM % 100 + 1))
    echo "Random number between 1 and 100: $random_number"
    echo
}

# Function to simulate a dice roll
simulate_dice_roll() {
    echo "=== Simulating Dice Rolls ==="
    local dice_roll=$((RANDOM % 6 + 1))
    echo "Dice roll: $dice_roll"
    echo
}

# Function to select a random option from a list
select_random_option_from_list() {
    echo "=== Random Selection from a List ==="
    local options=("apple" "banana" "cherry")
    local random_option=${options[$((RANDOM % ${#options[@]}))]}
    echo "Selected option: $random_option"
    echo
}

# Function to generate a random file name
generate_random_file_name() {
    echo "=== Random File Name Generation ==="
    local file_name="data_$(date +%s)_$RANDOM.txt"
    echo "Generated file name: $file_name"
    echo
}

# Function to generate a random password
generate_random_password() {
    echo "=== Random Password Generation ==="
    local password=$(</dev/urandom tr -dc A-Za-z0-9 | head -c12)
    echo "Generated password: $password"
    echo
}

# Function to generate a random IP address
generate_random_ip_address() {
    echo "=== Random IP Address ==="
    local ip_address=$(echo "$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))")
    echo "Generated IP address: $ip_address"
    echo
}

# Function to generate a random color in hex format
generate_random_color_hex() {
    echo "=== Random Color in Hex Format ==="
    local color=$(printf "%06X\n" $RANDOM)
    echo "Random color (hex): #$color"
    echo
}

# Function to generate a random date between two dates
generate_random_date_between_two_dates() {
    echo "=== Random Date Between Two Dates ==="
    local start_date="2023-01-01"
    local end_date="2023-12-31"

    local start_timestamp=$(date -ud "$start_date" +%s)
    local end_timestamp=$(date -ud "$end_date" +%s)

    # Calculate the total number of days between start and end date
    local total_days=$(((end_timestamp - start_timestamp) / 86400))

    # Generate a random number of days within the range
    local random_days=$((RANDOM % (total_days + 1)))

    # Add the random days to the start date
    local random_date=$(date -d "$start_date + $random_days days" +"%Y-%m-%d")

    echo "Random date between $start_date and $end_date: $random_date"
    echo
}

# Function to generate a random alphanumeric string
generate_random_alphanumeric_string() {
    echo "=== Random String of Alphanumeric Characters ==="
    local random_string=$(</dev/urandom tr -dc A-Za-z0-9 | head -c10)
    echo "Generated string: $random_string"
    echo
}

# Main entry point function
main() {
    generate_basic_random_number
    generate_random_number_between_1_and_100
    simulate_dice_roll
    select_random_option_from_list
    generate_random_file_name
    generate_random_password
    generate_random_ip_address
    generate_random_color_hex
    generate_random_date_between_two_dates
    generate_random_alphanumeric_string
}

# Call the main function if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
