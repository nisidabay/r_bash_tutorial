#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 04_while_until.sh — While and until loops
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── while loop (runs while condition is true) ────────────────
echo "=== while: count down ==="
count=3
while (( count > 0 )); do
    echo "  Countdown: $count"
    (( count-- ))
done
echo "  Blast off!"

# ── until loop (runs while condition is false) ───────────────
# until is the opposite of while — it runs UNTIL the condition becomes true
echo ""
echo "=== until: count up ==="
count=1
until (( count > 3 )); do
    echo "  Counting: $count"
    (( count++ ))
done

# ── Reading lines with while read ────────────────────────────
# while read — the idiomatic way to process text line by line
# IFS= prevents stripping leading/trailing whitespace
# -r prevents backslash interpretation
echo ""
echo "=== while read: processing lines ==="
sample_data="line one
line two
line three"

while IFS= read -r line; do
    echo "  Read: $line"
done <<< "$sample_data"

# ── Reading from a pipeline ──────────────────────────────────
# process substitution is cleaner than piping into while
echo ""
echo "=== while read with process substitution ==="
while IFS= read -r user; do
    echo "  User directory: /home/$user"
done < <(printf "%s\n" "alice" "bob" "charlie")

# ── while true (infinite loop) ───────────────────────────────
# Use with break to exit, or a counter to demonstrate
echo ""
echo "=== while true with break ==="
counter=0
while true; do
    (( ++counter ))    # pre-increment avoids exit code 1 on counter=0
    echo "  Iteration $counter"
    if (( counter >= 3 )); then
        echo "  Breaking after 3 iterations"
        break
    fi
done