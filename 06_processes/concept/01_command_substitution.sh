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
    # shellcheck disable=SC2006  # intentional legacy syntax demo
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
    # shellcheck disable=SC2012  # intentional: teaching ls usage, not find
    files=$(ls -la | wc -l)
    echo "Files in current dir: $files"
}
main "$@"
