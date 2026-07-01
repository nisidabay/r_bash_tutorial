#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 03 (Functions)
# ──────────────────────────────────────────────────────────────

failures=0

run_test() {
    local name="$1"
    local script="$2"
    local args="$3"
    local expected="$4"

    if [[ -f "$script" ]]; then
        if [[ -n "$args" ]]; then
            output=$(bash "$script" $args 2>&1) || true
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

run_test "exercise_1B (validador)" \
    "exercises/03_functions/solutions/validador.sh" \
    "test@example.com" \
    "email"

run_test "exercise_2A (local_vars)" \
    "exercises/03_functions/exercise_2A.sh" \
    "" \
    "Contador global"

exit "$failures"
