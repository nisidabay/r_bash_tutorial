#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 07_word_frequency.sh — Word frequency counter
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Word Frequency ───────────────────────────────────────────
# Reads text from stdin (or a file), counts word frequencies,
# and prints a sorted report.
# Arguments: optional file path (reads stdin if omitted)
word_frequency() {
    local input_file="${1:-/dev/stdin}"
    declare -A freq

    # Read words, convert to lowercase, remove punctuation, count
    while IFS= read -r line; do
        # Skip empty lines
        [[ -z "$line" ]] && continue

        # Split line into words, lowercase, strip punctuation
        for word in $line; do
            # Lowercase and strip non-alphanumeric from edges
            local clean
            clean=$(echo "$word" | tr '[:upper:]' '[:lower:]' | sed 's/^[^a-z0-9]*//;s/[^a-z0-9]*$//')
            [[ -z "$clean" ]] && continue
            ((freq["$clean"]++))
        done
    done < "$input_file"

    # Print results sorted by frequency (descending)
    # Bash can't sort associative arrays natively, so we dump and sort
    for word in "${!freq[@]}"; do
        echo "${freq[$word]} $word"
    done | sort -rn
}

# ── Main ─────────────────────────────────────────────────────
main() {
    local input="${1:-}"

    echo "=== Word Frequency Report ==="
    echo ""

    if [[ -n "$input" ]]; then
        echo "Source: $input"
        echo "------------------------"
        word_frequency "$input"
    else
        echo "Source: stdin (pipe some text)"
        echo "------------------------"
        word_frequency
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
