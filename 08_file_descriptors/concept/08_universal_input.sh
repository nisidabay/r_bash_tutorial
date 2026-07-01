#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Universal Input Handler for Files or Pipes
#
# This script demonstrates a standard and robust pattern for writing command-line
# tools in Bash that can accept input from either a file specified as an
# argument or from standard input (stdin) via a pipe.
#
# How it Works:
# 1. It checks if an argument was provided (`$# -gt 0`).
# 2. If an argument is given, it's treated as an input filename. The script
#    validates that the file exists and is readable.
# 3. If no arguments are given, the script assumes the input is coming from
#    stdin (e.g., from a pipe or user typing).
# 4. A `while read` loop is used as the single, universal processing mechanism.
#    The loop's input is redirected from the specified file or from stdin.
#
# This pattern makes the script versatile and follows Unix philosophy.
#
# Examples:
#   ./handle_input.sh my_file.txt    # Reads from a file
#   cat my_file.txt | ./handle_input.sh # Reads from a pipe
# ==============================================================================

# --- Main Logic ---
main() {
    # shellcheck disable=SC2034  # intentional: variable documents the input source
    local input_source="stdin"
    local input_filename=""

    # --- Determine Input Source ---
    if [[ $# -gt 0 ]]; then
        # An argument was provided, treat it as a filename.
        input_filename="$1"
        # shellcheck disable=SC2034  # intentional: documents input source
        input_source="file"

        # Validate that the file exists and is readable.
        if [[ ! -r "$input_filename" ]]; then
            echo "Error: Input file '$input_filename' not found or is not readable." >&2
            exit 1
        fi
        echo "Processing input from file: '$input_filename'"
    else
        # No arguments, so expect input from stdin.
        # Check if stdin is a pipe or a terminal.
        if [[ -t 0 ]]; then
            echo "No file provided. Waiting for input from the terminal (end with Ctrl+D)..."
        else
            echo "Processing input from stdin (pipe)..."
        fi
    fi

    echo "--- Start of Content ---"

    # --- Universal Processing Loop ---
    # This loop processes the input, regardless of its source.
    local line_count=0
    while IFS= read -r line; do
        # Process each line here. For this demo, we just print it.
        printf "Line %d: %s\n" "$((++line_count))" "$line"
    done < "${input_filename:-/dev/stdin}" # Magic part!

    # Explanation of `< "${input_filename:-/dev/stdin}"`:
    # - This is a redirection to the `while` loop.
    # - `${input_filename:-/dev/stdin}` is a parameter expansion.
    #   - If `$input_filename` is set and not empty, its value is used (e.g., "my_file.txt").
    #   - If `$input_filename` is unset or empty, the default value `/dev/stdin` is used.
    #   - `/dev/stdin` is a special file that represents the standard input stream.

    echo "--- End of Content ---"
    echo "Processed $line_count lines in total."
}

# --- Script Entry Point ---
main "$@"
