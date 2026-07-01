#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Top-level runner for all exercise groups
# ──────────────────────────────────────────────────────────────
# Runs each group's verify.sh and reports aggregate results.
# ──────────────────────────────────────────────────────────────

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
total_failures=0
total_tests=0  # not used directly, tracked via passed+failed counts
passed=0
failed=0

echo "═══════════════════════════════════════════════════════════"
echo "  r_bash_tutorial — Exercise Verification Suite"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Ordered list of group directories (matching the tutorial structure)
groups=(
    "01_basics"
    "02_control_flow"
    "03_functions"
    "04_arrays_strings"
    "05_file_io_basics"
    "06_processes"
    "07a_case_flow"
    "07b_namerefs_data"
    "07c_argument_parsing"
    "08_file_descriptors"
    "09_system_admin"
    "10_terminal_ui"
    "11_algorithms_data"
)

for group in "${groups[@]}"; do
    verify_script="$ROOT/$group/verify.sh"

    if [[ ! -f "$verify_script" ]]; then
        echo "⚠  No verify.sh found for group '$group' — skipping."
        echo ""
        continue
    fi

    echo "─── Running: $group ───"

    # Run the group verify.sh, capture exit code (failures count)
    set +e
    output=$("$verify_script" 2>&1)
    exit_code=$?
    set -euo pipefail

    # Count PASS/FAIL lines using grep -o and wc -l (safer with pipefail)
    group_passed=$(echo "$output" | grep -o '^PASS:' | wc -l)
    group_failed=$(echo "$output" | grep -o '^FAIL:' | wc -l)
    ((passed += group_passed))
    ((failed += group_failed))
    ((total_failures += exit_code))

    # Print the output (indented), using a while loop with process substitution
    while IFS= read -r line; do
        echo "  $line"
    done < <(echo "$output")

    echo ""
done

# ── Summary ──────────────────────────────────────────────────
echo "═══════════════════════════════════════════════════════════"
echo "  Results: $passed passed, $failed failed"
echo "  Group failures (exit codes): $total_failures"
echo "═══════════════════════════════════════════════════════════"

exit "$total_failures"
