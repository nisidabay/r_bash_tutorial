#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Processing a Multi-line String with a Here String (`<<<`)
#
# This script demonstrates how to use a "here string" (`<<<`) to redirect the
# contents of a variable as standard input to a command, typically a `while read`
# loop. This is a very common and efficient pattern for processing multi-line
# strings line by line in Bash.
#
# A here string is generally preferred over `echo "$variable" | ...` because it
# does not create a subshell, which is more memory-efficient and allows variables
# modified inside the loop (if any) to persist in the script's main scope.
#
# How it Works:
# 1. A multi-line string is stored in the `content` variable using a `cat`
#    here-document (`<<-EOF`). The `<<-` variant allows leading tabs in the
#    here-document to be ignored, which is useful for code indentation.
# 2. `done <<< "$content"`: The here string operator (`<<<`) takes the string
#    from the `$content` variable and provides it as standard input to the
#    `while` loop.
# ==============================================================================

main() {
    # Create a multi-line variable using a here-document.
    local content
    content=$(cat <<-EOF
	Line 1: Lorem ipsum dolor sit amet, consectetur adipiscing elit.
	Line 2: Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
	Line 3: Ut enim ad minim veniam, quis nostrud exercitation.
	EOF
    )

    echo "--- Processing content from a variable line by line ---"

    local line_num=0
    # The `while` loop reads from the here string.
    # `IFS=` is used to prevent `read` from trimming leading/trailing whitespace.
    # `-r` prevents `read` from interpreting backslashes.
    while IFS= read -r line; do
        ((line_num++))
        printf "  Line %d: %s\n" "$line_num" "$line"
    done <<<"$content"

    echo "-----------------------------------------------------"
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
