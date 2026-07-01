#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 06_ifs.sh — IFS (Internal Field Separator) and word splitting
# ──────────────────────────────────────────────────────────────
set -euo pipefail
# NOTE: We set IFS below per-section for demonstration.
# In production scripts, set IFS=$'\n\t' at the top.

# ── Default IFS: space/tab/newline ───────────────────────────
# By default IFS=" \t\n" — Bash splits unquoted variables on these
# We temporarily set IFS to default to demonstrate:
IFS=$' \t\n'

data="apple banana cherry"
echo "Default IFS: splitting on spaces"
for fruit in $data; do
    echo "  Fruit: $fruit"
done

# ── IFS=$'\n\t' — safe splitting (newlines only) ─────────────
# Setting IFS to newline+tab means spaces are NOT word separators
# This is why we set it at the top of production scripts
IFS=$'\n\t'

lines="line with spaces
second entry
third entry"
echo ""
# shellcheck disable=SC2028  # intentional: showing escape sequences in echo
echo "IFS=\$'\\n\\t': splitting on newlines (spaces preserved)"
for entry in $lines; do
    echo "  Entry: '$entry'"
done

# ── Changing IFS for parsing ─────────────────────────────────
# Set IFS to colon (:) to parse PATH-style data
echo ""
echo "Parsing colon-separated data (IFS=:):"
path_entry="/usr/local/bin:/usr/bin:/bin"
IFS=":"
for dir in $path_entry; do
    echo "  Dir: $dir"
done

# ── IFS and arrays ───────────────────────────────────────────
# IFS controls how "${array[*]}" joins elements
echo ""
IFS=","
colors=("red" "green" "blue")
echo "Joined with IFS=,: ${colors[*]}"

IFS=" | "
echo "Joined with IFS=' | ': ${colors[*]}"

# ── Safer: saving and restoring IFS ──────────────────────────
echo ""
echo "Best practice: save and restore IFS"
parse_csv() {
    local line="$1"
    local saved_ifs="$IFS"
    IFS=","
    # shellcheck disable=SC2086  # intentional word splitting on comma
    set -- $line
    IFS="$saved_ifs"
    echo "  Fields: $#"
}

parse_csv "alice,bob,charlie"