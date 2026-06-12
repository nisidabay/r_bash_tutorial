#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 03_for_loop.sh — All flavors of the for loop
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── for i in ... (iterate over words) ────────────────────────
echo "=== Iterating over a list of words ==="
for fruit in apple banana cherry date; do
    echo "  Fruit: $fruit"
done

# ── Brace expansion {1..5} ───────────────────────────────────
# {START..END} expands to a sequence of numbers
echo ""
echo "=== Brace expansion: {1..5} ==="
for i in {1..5}; do
    echo "  Count: $i"
done

# {START..END..STEP} for custom step
echo ""
echo "=== Brace expansion: {0..10..2} ==="
for i in {0..10..2}; do
    echo "  Even: $i"
done

# ── Iterating over files with glob ───────────────────────────
# Globs expand to matching filenames (no ls parsing needed!)
echo ""
echo "=== Files in current directory (*.sh) ==="
for file in *.sh; do
    if [[ -f "$file" ]]; then
        echo "  Script: $file ($(wc -l < "$file") lines)"
    fi
done 2>/dev/null || echo "  (no .sh files in current dir)"

# ── C-style for loop ─────────────────────────────────────────
# (( init; condition; increment )) — familiar to C/JS/Java programmers
echo ""
echo "=== C-style: for ((i=0; i<5; i++)) ==="
for ((i=0; i<5; i++)); do
    echo "  Index: $i"
done

# ── Iterating over command output ────────────────────────────
# Use arrays to safely capture command output
echo ""
echo "=== Iterating over command output ==="
users=("alice" "bob" "charlie")
for user in "${users[@]}"; do
    echo "  User: $user"
done