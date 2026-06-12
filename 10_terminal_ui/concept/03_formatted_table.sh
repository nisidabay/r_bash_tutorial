#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Multiplication Table Generator
#
# This script generates a formatted multiplication table of a given size.
#
# Usage:
#   ./multiplication_table.sh [size]
#
# If `size` is not provided, it defaults to 10. The size must be a positive
# integer.
#
# The script uses `printf` for precise, formatted output to align the columns
# correctly.
# ==============================================================================

# --- Main Logic ---
main() {
    # --- Input Validation ---
    local size="${1:-10}" # Default to 10 if no argument is given.

    # Regular expression to check if the input is a positive integer.
    if ! [[ "$size" =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: Please provide a positive integer for the size." >&2
        echo "Usage: ${0##*/} [size]" >&2
        exit 1
    fi

    # Width for each cell in the table.
    local cell_width=4

    # --- Header Row ---
    # Print the top-left corner padding.
    printf "%${cell_width}s|" ""
    # Print the column headers.
    for ((i = 1; i <= size; i++)); do
        printf "%${cell_width}d" "$i"
    done
    printf "\n"

    # --- Separator Line ---
    # Print the initial part of the separator.
    printf -- "-%.0s" $(seq 1 $cell_width) # Prints `cell_width` hyphens
    printf "+"
    # Print the rest of the separator line.
    for ((i = 1; i <= size * cell_width; i++)); do
        printf "-"
    done
    printf "\n"

    # --- Table Body ---
    # Outer loop for rows.
    for ((i = 1; i <= size; i++)); do
        # Print the row header.
        printf "%${cell_width}d|" "$i"
        # Inner loop for columns.
        for ((j = 1; j <= size; j++)); do
            # Print the calculated product, padded to the cell width.
            printf "%${cell_width}d" "$((i * j))"
        done
        # Move to the next line after each row is complete.
        printf "\n"
    done

    echo -e "\nFinished generating a ${size}x${size} multiplication table."
}

# --- Script Entry Point ---
main "$@"
