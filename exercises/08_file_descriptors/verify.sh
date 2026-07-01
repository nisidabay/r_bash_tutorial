#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 08 (File Descriptors)
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

# Create temp files for fd_compare test
tmp1=$(mktemp)
tmp2=$(mktemp)
echo "linea1" > "$tmp1"
echo "linea1" > "$tmp2"

run_test "exercise_1A (fd_compare)" \
    "exercises/08_file_descriptors/exercise_1A.sh" \
    "$tmp1 $tmp2" \
    "Comparando"

run_test "exercise_2A (fd_logging)" \
    "exercises/08_file_descriptors/exercise_2A.sh" \
    "" \
    "INFO"

run_test "exercise_3A (fd_timeout)" \
    "exercises/08_file_descriptors/exercise_3A.sh" \
    "" \
    "Timeout"

rm -f "$tmp1" "$tmp2"

exit "$failures"
