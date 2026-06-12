#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 06_break_continue.sh — break and continue in loops
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── break: exit a loop early ─────────────────────────────────
# break terminates the current loop immediately
echo "=== break: stop at 3 ==="
for i in {1..5}; do
    if (( i == 3 )); then
        echo "  Breaking at $i"
        break
    fi
    echo "  Number: $i"
done

# ── continue: skip one iteration ─────────────────────────────
# continue skips the rest of the current iteration and moves to the next
echo ""
echo "=== continue: skip even numbers ==="
for i in {1..6}; do
    if (( i % 2 == 0 )); then
        continue   # skip even numbers
    fi
    echo "  Odd: $i"
done

# ── break N: exit N levels of nested loops ───────────────────
# break N exits not just the current loop, but N levels up
echo ""
echo "=== break 2: exit outer loop from inner ==="
for outer in {1..3}; do
    echo "  Outer: $outer"
    for inner in {1..3}; do
        echo "    Inner: $inner"
        if (( outer == 2 && inner == 2 )); then
            echo "    Breaking out of both loops! (break 2)"
            break 2
        fi
    done
done
echo "  After both loops"

# ── continue N: rare but possible ────────────────────────────
# continue N continues the Nth enclosing loop
echo ""
echo "=== continue 2: continue outer loop from inner ==="
for outer in a b c; do
    echo "  Outer start: $outer"
    for inner in 1 2 3; do
        if [[ "$outer" == "b" && "$inner" == 2 ]]; then
            echo "    Skipping rest of outer 'b' (continue 2)"
            continue 2
        fi
        echo "    Inner: $outer-$inner"
    done
    echo "  Outer end: $outer"
done