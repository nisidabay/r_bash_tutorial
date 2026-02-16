#!/usr/bin/env bash
#
# Log to a file using file descriptors

set -uo pipefail

# Error handling function
handle_error() {
    local error_code=$?
    local line=$1
    echo "ERROR on line $line (exit code: $error_code)" >&2
    exit 1
}

# Trap error handling
trap 'handle_error $LINENO' ERR

main() {
    local count=0

    if ! touch script_activity.log 2>/dev/null; then
        handle_error $LINENO
    fi

    exec 3>>script_activity.log

    log_message() {
        local message="$1"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >&3
    }

    log_message "Script started"

    for file in *.sh; do
        log_message "Processing file: $file"
        # Process file...
        ((count++))
    done

    if [[ $count -eq 0 ]]; then
        log_message "No .sh files found"
    fi

    log_message "Script completed"

    # Close log file
    exec 3>&-
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
