#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Writing to a File Using a Dedicated File Descriptor
#
# This script demonstrates the proper way to open a file for writing once and
# then append to it multiple times using a dedicated file descriptor. This is
# more efficient than using the `>>` append operator for every write operation.
#
# How it Works:
# 1. `exec 3>> "$LOG_FILE"`: Opens the log file in append mode and assigns it
#    to file descriptor 3.
# 2. `echo "Message" >&3`: The `>&3` syntax redirects the `echo` command's
#    standard output to file descriptor 3, which in turn writes it to the file.
# 3. `exec 3>&-`: The file descriptor is explicitly closed at the end, which is
#    a crucial cleanup step.
# ==============================================================================

# --- Global Configuration ---
declare -g LOG_FILE="fd_write_log.txt"

# --- Error Handling ---
handle_error() {
    local exit_code=$?
    local line_num=$1
    local message=${2:-"An unexpected error occurred."}
    echo "ERROR on line ${line_num}: ${message} (exit code: ${exit_code})" >&2
    # Ensure the file descriptor is closed on error.
    exec 3>&- 2>/dev/null
    exit "$exit_code"
}
trap 'handle_error $LINENO' ERR

# --- Main Logic ---
main() {
    # Check if the target directory is writable.
    local log_dir
    log_dir=$(dirname "$LOG_FILE")
    if [[ ! -w "$log_dir" ]]; then
        # We can't use the error handler yet as the trap is not set inside a function.
        echo "Error: Cannot write to directory '$log_dir'." >&2
        exit 1
    fi

    # Ensure the log file is cleaned up on exit.
    trap 'rm -f "$LOG_FILE"' EXIT

    # Open file descriptor 3 for appending to the log file.
    # The file will be created if it doesn't exist.
    exec 3>>"$LOG_FILE"

    echo "Script started, logging to '$LOG_FILE'..."

    # Write messages to the log file via file descriptor 3.
    echo "Script started at $(date)" >&3
    echo "Processing data..." >&3
    for i in {1..5}; do
        echo "Log entry $i" >&3
        sleep 0.1
    done
    echo "Processing complete." >&3

    # Close the file descriptor.
    exec 3>&-

    echo "Script finished. See '$LOG_FILE' for output."
    echo "--- Contents of $LOG_FILE ---"
    cat "$LOG_FILE"
    echo "---------------------------"
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
