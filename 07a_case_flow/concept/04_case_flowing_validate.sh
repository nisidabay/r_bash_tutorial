#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Bash `case` Statement Flow Control Demo 3: Multi-condition check
#
# This script uses the `;&&` (test next) operator to validate if an input
# string meets multiple criteria.
# ==============================================================================

validate_input() {
    local input="$1"
    local has_numbers=false
    local has_letters=false

    echo "Analyzing input: '$input'"
    echo -n "Output: "

    case $input in
        # Pattern 1: Does it contain at least one number?
        *[0-9]*)
            has_numbers=true
            # `;&&` (Test Next): Continue to the next pattern to see if it also matches.
            ;;&

        # Pattern 2: Does it contain at least one letter?
        *[a-zA-Z]*)
            has_letters=true
            # `;;` (Stop): We don't need to check any more patterns.
            ;;
    esac

    # Now, check the flags to give a final result.
    if [[ "$has_numbers" == true && "$has_letters" == true ]]; then
        echo "SUCCESS: Input contains both numbers and letters."
    elif [[ "$has_numbers" == true ]]; then
        echo "FAIL: Input only contains numbers."
    elif [[ "$has_letters" == true ]]; then
        echo "FAIL: Input only contains letters."
    else
        echo "FAIL: Input does not contain numbers or letters."
    fi
}

# --- Demo ---
echo "--- Test Case 1: Mixed ---"
validate_input "abc123"
echo
echo "--- Test Case 2: Numbers only ---"
validate_input "12345"
echo
echo "--- Test Case 3: Letters only ---"
validate_input "abcde"
echo
echo "--- Test Case 4: Symbols only ---"
validate_input "!@#$%"
echo
