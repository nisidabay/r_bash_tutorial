#!/usr/bin/env bash

# ==============================================================================
# Script Name:    template.sh
# Description:    Advanced bash Boilerplate with error handling and best practices
# Configuration (optional)
# ==============================================================================
# Set DEBUG=1 in your environment to enable debug logs.
# Example: DEBUG=1 ./template.sh input.txt
# ==============================================================================

# 1. Environment Setup & Safety
set -euo pipefail
IFS=$'\n\t'

# 2. Read-only Constants
readonly SCRIPT_NAME="${0##*/}"

#shellcheck disable=SC2034
#shellcheck disable=SC2155
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
#shellcheck disable=SC2034
readonly VERSION="1.0.0"

# 3. Logging Levels
readonly LOG_ERROR=0
readonly LOG_WARN=1
readonly LOG_INFO=2
readonly LOG_DEBUG=3

# 4. Global Temp File Handle (initialized early for set -u safety)
TMP_FILE=""

# 5. Cleanup & Error Handling
cleanup() {
    local exit_code=$?
    # Clean up temp files safely
    if [[ -n "${TMP_FILE:-}" && -f "$TMP_FILE" ]]; then
        rm -f "$TMP_FILE"
    fi
    exit "$exit_code"
}

trap cleanup EXIT

# 6. Helper Functions
log() {
    local level="$1"
    shift
    local message="$*"
    # Only show debug logs if DEBUG environment variable is set
    [[ $level -eq $LOG_DEBUG && -z "${DEBUG:-}" ]] && return

    printf '[%s] [%s]: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" \
        "${SCRIPT_NAME}" "${message}" >&2
}

die() {
    log "$LOG_ERROR" "$*"
    exit 1
}

# 7. Core Logic
process_data() {
    local input_path="$1"
    log "$LOG_INFO" "Processing file: $input_path"

    # Example: Advanced Process Substitution (comparing input to a sorted version)
    if ! diff "$input_path" <(sort "$input_path") >/dev/null; then
        log "$LOG_WARN" "File is not sorted alphabetically."
    fi
}

# 8. Main Execution Block
main() {
    # Check for arguments
    if [[ $# -eq 0 ]]; then
        die "No input file provided. Usage: $SCRIPT_NAME <filename>"
    fi

    local target_file="$1"

    # Validation
    if [[ ! -f "$target_file" ]]; then
        die "File not found: $target_file"
    fi

    # Initialize secure temp file
    TMP_FILE=$(mktemp)

    process_data "$target_file"

    log "$LOG_INFO" "Script completed successfully."
}

# 9. Entry Point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
