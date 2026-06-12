#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 05_echo_printf.sh — echo vs printf for formatted output
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── echo basics ──────────────────────────────────────────────
# echo is simple: prints args separated by spaces, followed by newline
echo "Hello, world!"
echo "Multiple" "args" "get" "space-separated"

# ── echo -n (no trailing newline) ────────────────────────────
echo -n "No newline after this... "
echo "continues on same line"

# ── echo -e (enable escape sequences) ────────────────────────
# -e enables interpretation of \n, \t, \\, etc.
echo -e "Line 1\nLine 2 (via echo -e)"
echo -e "Column 1\tColumn 2\tColumn 3"

# ── printf basics ────────────────────────────────────────────
# printf FORMAT [ARGUMENTS...] — more control, more portable
# Format string is reused until all args are consumed
echo ""
printf "Hello, %s!\n" "World"
printf "Name: %s, Age: %d\n" "Alice" 30 "Bob" 25

# ── printf format specifiers ─────────────────────────────────
echo ""
printf "%%s = string:     %s\n" "hello"
printf "%%d = integer:    %d\n" 42
printf "%%f = float:      %f\n" 3.14159
printf "%%.2f = 2 decimals: %.2f\n" 3.14159

# ── Alignment with printf ────────────────────────────────────
echo ""
printf "┌────────────────────────────────┐\n"
printf "│ %-20s │ %5s │\n" "Name" "Score"
printf "│────────────────────────────────│\n"
printf "│ %-20s │ %5d │\n" "Alice" 95
printf "│ %-20s │ %5d │\n" "Bob" 87
printf "│ %-20s │ %5d │\n" "Charlie" 100
printf "└────────────────────────────────┘\n"

# ── echo vs printf: when to use each ─────────────────────────
# echo: quick output, simple messages, user-facing scripts
# printf: formatted tables, numbers with precision, portable scripts