#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Bash `case` Statement Flow Control Demo 2
#
# This script provides another example of the non-portable `;&` (fallthrough)
# and `;&&` (test next) operators in Bash's `case` statement.
# ==============================================================================

# --- Demo ---
file="photo.jpg"
echo "Analyzing file: '$file'"
echo -n "Output: "

case $file in
    # Pattern 1: Does it end with ".jpg"?
    *.jpg)
        echo -n "Image "
        # `;&` (Fallthrough): Unconditionally jump to the next block (`ignored`).
        # The pattern "ignored" will not be tested.
        ;&

    # Pattern 2: (This pattern will never match the input `photo.jpg`)
    # This block is executed ONLY because of the fallthrough from the `;&` above.
    ignored)
        echo -n "Format "
        # `;&&` (Test Next): Continue to the next pattern (`photo*`) and evaluate it.
        ;;&

    # Pattern 3: Does it start with "photo"?
    # This block is executed because the `;&&` above told the case to keep testing,
    # AND the pattern `photo*` matches the input "photo.jpg".
    photo*)
        echo -n "named Photo "
        # `;;` (Stop): The case statement terminates here.
        ;;
esac

echo # Add a final newline.

# Expected Output: Image Format named Photo
