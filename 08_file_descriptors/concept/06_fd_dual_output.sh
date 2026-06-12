#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Logging to Both a File and the Console
#
# This script demonstrates a common requirement: logging script activity to a
# file for later inspection while also printing status messages to the console
# for the user to see in real-time.
#
# It uses a dedicated file descriptor (FD 3) for the log file and the `tee`
# command for simultaneous output.
#
# How it Works:
# 1. `exec 3>> "$LOG_FILE"`: Opens the log file in append mode and assigns it
#    to file descriptor 3. Any output sent to FD 3 will be written to this file.
# 2. `log_message` function: This function takes a message, prepends a
#    timestamp, and then pipes it to `tee`.
# 3. `tee -a /dev/fd/3`: `tee` reads from its standard input and writes that
#    input to two places:
#    - Standard output (which is the console by default).
#    - The file specified. Here, we use `/dev/fd/3`, which is a special path
#      that points to the file opened on file descriptor 3 (our log file).
#      The `-a` flag tells `tee` to append to the file, not overwrite it.
# ==============================================================================

# --- Configuration ---
readonly LOG_FILE="script_activity.log"

# --- Error Handling ---
# A more robust error handler would also close the file descriptor.
handle_error() {
    local exit_code=$?
    local line_num=$1
    # Log the error to stderr and the log file if possible.
    local error_message="ERROR on line $line_num (exit code: $exit_code)"
    log_message "$error_message" >&2
    exit "$exit_code"
}
trap 'handle_error $LINENO' ERR

# --- Logging Function ---
# This function logs a message to both the console (stdout) and the log file (FD 3).
log_message() {
    # Prepend a timestamp to the message.
    local message
    message="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    # Use `tee` to send the message to stdout and to the file descriptor.
    echo "$message" | tee -a /dev/fd/3
}

# --- Main Logic ---
main() {
    # Attempt to create/touch the log file to check for write permissions.
    if ! touch "$LOG_FILE" 2>/dev/null; then
        echo "Error: Cannot write to log file at '$LOG_FILE'." >&2
        exit 1
    fi

    # Open file descriptor 3 for appending to the log file.
    exec 3>>"$LOG_FILE"

    log_message "Script started."

    local count=0
    # Use a safer globbing pattern.
    shopt -s nullglob
    local files=(*.txt *.log)
    shopt -u nullglob

    for file in "${files[@]}"; do
        log_message "Processing file: $file"
        # Simulate processing the file...
        sleep 0.1
        ((count++))
    done

    if ((${#files[@]} == 0)); then
        log_message "No .txt or .log files found in the current directory."
    fi

    log_message "Script completed. Processed $count files."

    # Close the log file descriptor.
    exec 3>&-
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
