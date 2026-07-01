#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Practical Example of `getopts` for Command-Line Option Parsing
#
# This script demonstrates how to use the built-in `getopts` command to parse
# command-line options in a standard and robust way.
#
# How `getopts` Works:
# - `getopts "optstring" varname`: It iterates through the script's arguments.
# - The `optstring` defines the valid options.
#   - A letter (e.g., `v`) defines a simple flag (`-v`).
#   - A letter followed by a colon (e.g., `f:`) defines an option that requires
#     an argument (`-f <argument>`).
#   - A leading colon (`:vf:n:h`) enables "silent" error handling, which allows
#     the script to catch errors (like missing arguments or invalid options)
#     itself instead of `getopts` printing its own error messages.
# - In each iteration, `getopts` sets `varname` to the option character found.
# - If an option requires an argument, `getopts` places it in the `OPTARG` variable.
# - `OPTIND` is a special variable that `getopts` uses to track the index of the
#   next argument to be processed.
# ==============================================================================

# --- Functions ---
display_help() {
    # Using a here-document for a clean, multi-line help message.
    cat <<EOF
Usage: ${0##*/} -f FILE -n NAME [-v] [-h]

A script to demonstrate getopts.

Required Arguments:
  -f FILE     Specify the input file.
  -n NAME     Specify a name to use.

Optional Arguments:
  -v          Enable verbose mode for extra output.
  -h          Display this help message and exit.
EOF
}

# --- Main Logic ---
main() {
    # Initialize variables with default values.
    local verbose=false
    local input_file=""
    local name=""

    # The `getopts` loop for parsing command-line options.
    while getopts ":vf:n:h" opt; do
        case $opt in
            v)
                verbose=true
                ;;
            f)
                input_file="$OPTARG"
                ;;
            n)
                name="$OPTARG"
                ;;
            h)
                display_help
                exit 0
                ;;
            \?) # Handle invalid options.
                echo "Error: Invalid option: -$OPTARG" >&2
                display_help
                exit 1
                ;;
            :) # Handle options that are missing a required argument.
                echo "Error: Option -$OPTARG requires an argument." >&2
                display_help
                exit 1
                ;;
        esac
    done

    # `shift` removes the parsed options from the argument list (`$@`).
    # After this, `$@` will only contain the remaining non-option arguments.
    shift $((OPTIND - 1))

    # --- Validation ---
    # Check if the mandatory arguments were provided.
    if [[ -z "$input_file" ]] || [[ -z "$name" ]]; then
        echo "Error: Both -f and -n options are required." >&2
        display_help
        exit 1
    fi

    # --- Script Execution ---
    echo "--- Script Starting ---"
    if [[ "$verbose" == true ]]; then
        echo "Verbose mode is enabled."
    fi

    echo "Processing file: '$input_file'"
    echo "Hello, $name!"

    # Check for any extra, non-option arguments.
    if [[ $# -gt 0 ]]; then
        echo "Note: The following additional arguments were provided but are not used:" "$@"
    fi

    echo "Script completed successfully."
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
