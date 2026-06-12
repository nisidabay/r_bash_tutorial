#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Reading from a File Descriptor
#
# This script demonstrates a robust pattern for processing input that can come
# from either command-line arguments or standard input (e.g., a pipe). It
# normalizes the input into a temporary file and then reads from that file
# using a dedicated file descriptor.
#
# Features:
# - Accepts input from arguments or a pipe.
# - Uses a temporary file to stage the input data.
# - Uses `exec` to assign a file descriptor for clean, explicit reading.
# - Includes `trap` for robust error handling and cleanup.
# - Includes a debug mode (`-d` or `--debug`).
# ==============================================================================

# --- Global Variables ---
declare -g DEBUG=false

# --- Error Handling ---
handle_error() {
    local exit_code=$?
    local line_num=$1
    local message=${2:-"An unexpected error occurred."}
    echo "ERROR on line ${line_num}: ${message} (exit code: ${exit_code})" >&2
    # The EXIT trap will handle file cleanup.
    exit "$exit_code"
}
trap 'handle_error $LINENO' ERR

# --- Argument Parsing ---
# This loop handles debug flags before the main script logic.
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d | --debug)
            DEBUG=true
            set -x # Turn on execution tracing.
            shift # Move to the next argument.
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            # This is not an option, so stop parsing.
            break
            ;;
    esac
done

# --- Main Logic ---
main() {
    # Create a temporary file to hold the input.
    local input_file
    input_file=$(mktemp)

    # Ensure the temporary file is removed when the script exits for any reason.
    trap 'rm -f "$input_file"' EXIT

    # --- Input Capture ---
    # Check if stdin is connected to a terminal (-t 0) AND if arguments were provided.
    if [[ -t 0 && -n "$*" ]]; then
        # If so, use the arguments as the input.
        printf "%s\n" "$@" >"$input_file"
    else
        # Otherwise, read from standard input (e.g., from a pipe `... | ./script.sh`).
        cat >"$input_file"
    fi

    # Check if we actually received any input.
    if [[ ! -s "$input_file" ]]; then
        echo "Warning: No input received." >&2
        exit 0
    fi

    # --- File Descriptor Processing ---
    # Open the temporary file for reading and assign it to file descriptor 3.
    exec 3<"$input_file"

    echo "--- Processing Input ---"
    # Read from file descriptor 3 line by line.
    # `read -r line <&3` is the portable equivalent of `read -r -u 3 line`.
    while IFS= read -r line <&3; do
        # Process the line (here, we just echo it).
        echo "Read line: ${line}"
    done
    echo "------------------------"

    # Close the file descriptor now that we're done with it.
    exec 3<&-

    # The EXIT trap will automatically clean up the temporary file.
}

# --- Script Entry Point ---
# This ensures `main` is called only when the script is executed directly.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
