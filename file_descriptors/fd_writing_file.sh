#!/usr/bin/env bash

set -euo pipefail

declare -g LOG_FILE="log_file.txt"
declare -g LOG_DIR

handle_error() {
    echo "Error on line $1: $2" >&2
    exit 1
}

trap 'handle_error $LINENO' ERR

cat <<EOF >fd_writing_file.sh
#!/usr/bin/env bash

set -euo pipefail

declare -g LOG_FILE="log_file.txt"
declare -g LOG_DIR

handle_error() {
	echo "Error on line $1: $2" >&2
	exit 1
}

trap 'handle_error $LINENO' ERR

main() {
	LOG_DIR=$(dirname "$LOG_FILE")

	if [[ ! -w "$LOG_DIR" ]]; then
		handle_error $LINENO "Cannot write to directory $LOG_DIR"
	fi

	echo "Script started at $(date)" >"$LOG_FILE"
	echo "Processing data..." >>"$LOG_FILE"
}

main "$@"
EOF
