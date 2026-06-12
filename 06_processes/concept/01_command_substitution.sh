#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 01_command_substitution.sh — $(command), backticks, nesting
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── Modern $(command) syntax ─────────────────────────────
    # Preferred over backticks — nests cleanly
    local current_date
    current_date=$(date +%Y-%m-%d)
    echo "Date: $current_date"

    # ── Legacy backtick syntax ───────────────────────────────
    # Still works but harder to nest
    local user_count
    user_count=`who | wc -l`
    echo "Logged-in users: $user_count"

    # ── Nesting ──────────────────────────────────────────────
    # $(command) nests easily inside another $()
    local dirname
    dirname=$(basename "$(pwd)")
    echo "Current directory: $dirname"

    # ── In strings ──────────────────────────────────────────
    echo "Hostname is $(hostname) and date is $(date +%F)"

    # ── Capturing in variables ──────────────────────────────
    local files
    files=$(ls -la | wc -l)
    echo "Files in current dir: $files"
}
main "$@"
