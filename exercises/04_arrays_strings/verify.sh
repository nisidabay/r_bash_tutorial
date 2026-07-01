#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 04 (Arrays & Strings)
# ──────────────────────────────────────────────────────────────

failures=0

run_test() {
    local name="$1"
    local script="$2"
    local input="$3"
    local expected="$4"

    if [[ -f "$script" ]]; then
        if [[ -n "$input" ]]; then
            output=$(echo "$input" | bash "$script" 2>&1) || true
        else
            output=$(bash "$script" 2>&1) || true
        fi
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

run_test "exercise_1B (mapfile+expansion)" \
    "exercises/04_arrays_strings/exercise_1B.sh" \
    "" \
    "Configuraci"

run_test "exercise_2A (assoc array)" \
    "exercises/04_arrays_strings/exercise_2A.sh" \
    "manzana\n100\npera\n200\nlisto\n" \
    "Total"

exit "$failures"
