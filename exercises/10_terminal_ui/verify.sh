#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 10 (Terminal UI)
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

run_test "exercise_1A (progress_bar)" \
    "exercises/10_terminal_ui/exercise_1A.sh" \
    "" \
    "Descarga"

run_test "exercise_2A (spinner)" \
    "exercises/10_terminal_ui/exercise_2A.sh" \
    "" \
    "Cargando"

run_test "exercise_3A (formatted_table)" \
    "exercises/10_terminal_ui/exercise_3A.sh" \
    "5" \
    "Pulgadas"

exit "$failures"
