#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Bash `case` Statement Flow Control: `;&` and `;&&`
#
# This script demonstrates the advanced, non-portable flow control operators
# available in Bash's `case` statement.
#
# - `;;`: The standard, POSIX-compliant terminator. It stops the `case`
#   statement after the commands in the current block are executed.
#
# - `;&`: (Fallthrough) This Bash extension causes execution to "fall through"
#   to the next pattern's block of commands *unconditionally*, without
#   evaluating the next pattern.
#
# - `;&&`: (Test Next) This Bash extension causes execution to continue to the
#   next pattern in the list and evaluate it. If it matches, its block of
#   commands is executed. This allows a single input to match multiple patterns.
#
# ==============================================================================

# --- Demo ---
drink="iced_latte"
echo "Analyzing drink: '$drink'"
echo -n "Output: "

case $drink in
    # Pattern 1: Does it start with "iced_"?
    iced_*)
        echo -n "Cold "
        # `;&` means FALL THROUGH to the next block (`*_latte`) without testing its pattern.
        # Execution will continue at `echo -n "Coffee "`.
        ;&

    # Pattern 2: Does it end with "_latte"?
    # This block is executed because of the fallthrough from the previous `;&`.
    *_latte)
        echo -n "Coffee "
        # `;&&` means CONTINUE TESTING. The script will now check the next pattern (`*latte`).
        # Since "iced_latte" also matches `*latte`, that block will also execute.
        ;;&

    # Pattern 3: Does it contain "latte"?
    # This block is executed because of the `;&&` above AND because the pattern matches.
    *latte)
        echo -n "with Milk "
        # `;;` is the standard terminator. The case statement stops here.
        ;;

    # Default/fallback pattern.
    *)
        echo "Water"
        ;;
esac

echo # Add a final newline for clean output.

# Expected Output: Cold Coffee with Milk
