#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 07c (Argument Parsing)
# ──────────────────────────────────────────────────────────────

failures=0

run_test() {
    local name="$1"
    local script="$2"
    local args="$3"
    local expected="$4"

    if [[ -f "$script" ]]; then
        output=$(bash "$script" $args 2>&1) || true
        if echo "$output" | grep -q "$expected"; then
            echo "PASS: $name"
        else
            echo "FAIL: $name — Expected pattern '$expected' not found"
            echo "       Output: $output"
            ((failures++))
        fi
    else
        echo "FAIL: $name — Script '$script' not found"
        ((failures++))
    fi
}

run_test "exercise_1A (getopts)" \
    "exercises/07c_argument_parsing/exercise_1A.sh" \
    "" \
    "Opción"

exit "$failures"
