#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Script Name:    template.sh
# Description:    An advanced Bash boilerplate with robust error handling,
#                 logging, argument parsing, and other best practices.
#
# Usage:
#   ./template.sh [options] <input_file>
#
# Environment Variables:
#   DEBUG=1: Set this environment variable to enable verbose debug logging.
#            Example: DEBUG=1 ./template.sh input.txt
#
# ==============================================================================

# 1. Environment Setup is handled at the top of the script.

# 2. Read-only Constants
readonly SCRIPT_NAME="${0##*/}"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly VERSION="1.0.1"

# 3. Logging Levels
# Using an associative array can be a more modern way to handle this.
# declare -A LOG_LEVELS=([error]=0 [warn]=1 [info]=2 [debug]=3)
readonly LOG_ERROR=0
readonly LOG_WARN=1
readonly LOG_INFO=2
readonly LOG_DEBUG=3

# 4. Global Temp File Handle (initialized early for `set -u` safety)
TMP_FILE=""

# 5. Cleanup & Error Handling
# This function is registered with `trap` and will be called on script exit.
cleanup() {
    local exit_code=$?
    # Clean up the temporary file if it was created.
    if [[ -n "${TMP_FILE:-}" && -f "$TMP_FILE" ]]; then
        rm -f "$TMP_FILE"
        log "$LOG_DEBUG" "Temporary file '$TMP_FILE' removed."
    fi
    # The script will exit with the same code it received.
    exit "$exit_code"
}

# The `trap` command ensures that the `cleanup` function is called on EXIT,
# which covers normal termination, signals (like Ctrl+C), and errors.
trap cleanup EXIT

# 6. Helper Functions

# A logging function that respects log levels and the DEBUG env var.
log() {
    local level="$1"
    shift
    local message="$*"
    # Do not print debug messages if DEBUG is not set to '1'.
    if [[ $level -eq $LOG_DEBUG && "${DEBUG:-}" != "1" ]]; then
        return
    fi

    # Print logs to stderr to separate them from the script's actual output (stdout).
    printf '[%s] [%s]: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" \
        "${SCRIPT_NAME}" "${message}" >&2
}

# A function to log an error message and exit the script with a failure code.
die() {
    log "$LOG_ERROR" "$*"
    exit 1
}

# 7. Core Logic
# A sample function demonstrating some processing.
process_data() {
    local input_path="$1"
    log "$LOG_INFO" "Processing file: '$input_path'"

    # Example of a check using process substitution.
    # This non-destructively checks if a file is sorted.
    if ! diff --brief "$input_path" <(sort "$input_path") >/dev/null; then
        log "$LOG_WARN" "File '$input_path' is not sorted alphabetically."
    else
        log "$LOG_INFO" "File '$input_path' is already sorted."
    fi

    log "$LOG_DEBUG" "Finished processing data from '$input_path'."
}

# 8. Main Execution Block
main() {
    log "$LOG_DEBUG" "Script starting."

    # A more advanced argument parsing loop.
    # while [[ $# -gt 0 ]]; do
    #     case "$1" in
    #         -h|--help) show_help; exit 0 ;;
    #         *) break ;; # First non-option argument
    #     esac
    #     shift
    # done

    # Check for the required file argument.
    if [[ $# -eq 0 ]]; then
        die "No input file provided. Usage: $SCRIPT_NAME <filename>"
    fi

    local target_file="$1"

    # Validate that the file exists and is a regular file.
    if [[ ! -f "$target_file" ]]; then
        die "File not found: '$target_file'"
    fi

    # Initialize a secure temporary file for this session.
    # This is safer than using predictable names in /tmp.
    TMP_FILE=$(mktemp)
    log "$LOG_DEBUG" "Created temporary file: $TMP_FILE"

    # Call the core logic function.
    process_data "$target_file"

    log "$LOG_INFO" "Script completed successfully."
}

# 9. Entry Point
# This standard construct ensures that `main` is called only when the script is
# executed directly, allowing its functions to be sourced by other scripts
# without automatically running.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
