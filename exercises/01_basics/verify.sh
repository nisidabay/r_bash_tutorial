#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 01 (Basics)
# ──────────────────────────────────────────────────────────────

failures=0

run_test() {
    local name="$1"
    local script="$2"
    local expected="$3"

    if [[ -f "$script" ]]; then
        output=$(bash "$script" 2>&1 <<< "TestUser") || true
        if echo "$output" | grep -q "$expected"; then
            echo "PASS: $name"
        else
            echo "FAIL: $name — Expected pattern '$expected' not found in output"
            echo "       Output: $output"
            ((failures++))
        fi
    else
        echo "FAIL: $name — Script '$script' not found"
        ((failures++))
    fi
}

run_test "exercise_1A (hello_variables)" \
    "exercises/01_basics/exercise_1A.sh" \
    "Hola"

run_test "exercise_2A (echo_printf)" \
    "exercises/01_basics/exercise_2A.sh" \
    "TOTAL"

run_test "exercise_3A (ifs)" \
    "exercises/01_basics/exercise_3A.sh" \
    "Unidos"

exit "$failures"
