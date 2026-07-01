#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 02 (Control Flow)
# ──────────────────────────────────────────────────────────────

failures=0

run_test() {
    local name="$1"
    local script="$2"
    local input="$3"
    local expected="$4"

    if [[ -f "$script" ]]; then
        output=$(echo "$input" | bash "$script" 2>&1) || true
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

run_test "exercise_1A (if_test)" \
    "exercises/02_control_flow/exercise_1A.sh" \
    "/tmp" \
    "directorio"

run_test "exercise_2A (for+break)" \
    "exercises/02_control_flow/exercise_2A.sh" \
    "" \
    "no se encontr"

run_test "exercise_3A (case)" \
    "exercises/02_control_flow/exercise_3A.sh" \
    "" \
    "Uso:"

exit "$failures"
