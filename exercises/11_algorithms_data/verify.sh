#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 11 (Algorithms)
# ──────────────────────────────────────────────────────────────

failures=0

run_test() {
    local name="$1"
    local script="$2"
    local args="$3"
    local expected="$4"

    if [[ -f "$script" ]]; then
        if [[ -n "$args" ]]; then
            output=$(timeout 3 bash "$script" $args 2>&1 || true)
        else
            output=$(timeout 3 bash "$script" 2>&1 || true)
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

run_test "exercise_1B (fake+search+rot13)" \
    "exercises/11_algorithms_data/exercise_1B.sh" \
    "" \
    "Usuarios"

run_test "exercise_2A (random_data)" \
    "exercises/11_algorithms_data/exercise_2A.sh" \
    "" \
    "TODO"

run_test "exercise_3A (rot13)" \
    "exercises/11_algorithms_data/exercise_3A.sh" \
    "" \
    "TODO"

exit "$failures"
