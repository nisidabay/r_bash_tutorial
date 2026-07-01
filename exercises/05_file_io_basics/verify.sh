#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 05 (File I/O)
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

run_test "exercise_1A (pipes)" \
    "exercises/05_file_io_basics/exercise_1A.sh" \
    "" \
    "->"

run_test "exercise_2B (dev_stdin)" \
    "exercises/05_file_io_basics/exercise_2B.sh" \
    "linea1\nlinea2" \
    "Procesadas"

exit "$failures"
