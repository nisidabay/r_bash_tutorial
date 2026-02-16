#!/usr/bin/env bash

set -euo pipefail

# Log to a file using file descriptors

handle_error() {
    echo "Error on line $1: $2" >&2
    exit 1
}

trap 'handle_error $LINENO' ERR

main() {
    local count=0

    if ! touch script_activity.log 2>/dev/null; then
        echo "Cannot write to log file" >&2
        exit 1
    fi

    exec 3>>script_activity.log

    log_message() {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >&3
    }

    log_message "Script started"

    for file in *.txt *.log; do
        log_message "Processing file: $file"
        # Process file...
        ((count++))
    done

    if [[ $count -eq 0 ]]; then
        log_message "No .txt or .log files found"
    fi

    log_message "Script completed"

    # Close log file
    exec 3>&-
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
