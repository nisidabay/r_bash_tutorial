#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Logging to a File Using a Dedicated File Descriptor
#
# This script demonstrates how to redirect output to a log file by using a
# custom file descriptor (FD). This technique is clean and efficient, as the
# log file only needs to be opened once.
#
# How it Works:
# 1. `exec 3>> "$LOG_FILE"`: This command opens the specified log file in
#    append mode (`>>`) and assigns it to file descriptor 3. From this point
#    on, any output redirected to `>&3` will be written to this file.
# 2. `log_message` function: This is a helper function that takes a message,
#    prepends a timestamp, and redirects the final string to FD 3 (`>&3`).
# 3. `exec 3>&-`: At the end of the script, this command explicitly closes the
#    file descriptor, releasing the file handle. This is important for clean
#    resource management.
# ==============================================================================

# --- Configuration ---
readonly LOG_FILE="script_activity.log"

# --- Error Handling ---
handle_error() {
    local exit_code=$?
    local line_num=$1
    local error_message="ERROR on line $line_num (exit code: $exit_code)"

    # Attempt to log the error to the file if the FD is still open.
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $error_message" >&3
    # Also print to stderr for immediate visibility.
    echo "$error_message" >&2

    # Ensure the file descriptor is closed before exiting.
    exec 3>&-
    exit "$exit_code"
}
trap 'handle_error $LINENO' ERR

# --- Logging Function ---
log_message() {
    # This function formats a message and sends it to file descriptor 3.
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&3
}

# --- Main Logic ---
main() {
    # Check for write permissions by trying to touch the file.
    if ! touch "$LOG_FILE" 2>/dev/null; then
        echo "Error: Cannot write to log file at '$LOG_FILE'." >&2
        exit 1
    fi

    # Open FD 3 for appending to the log file.
    exec 3>>"$LOG_FILE"

    log_message "Script started."
    echo "Script started. All output is being logged to '$LOG_FILE'."

    local count=0
    # Use nullglob for safe iteration over files.
    shopt -s nullglob
    local files=(*.sh)
    shopt -u nullglob

    for file in "${files[@]}"; do
        log_message "Processing file: $file"
        # Simulate work...
        sleep 0.1
        ((count++))
    done

    if ((${#files[@]} == 0)); then
        log_message "No .sh files found to process."
    fi

    log_message "Script completed. Processed $count files."

    # Close the log file descriptor.
    exec 3>&-

    echo "Script finished. See '$LOG_FILE' for details."
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
