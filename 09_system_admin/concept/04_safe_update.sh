#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# In-place File Update with Diff Confirmation
#
# This script demonstrates a safe and robust pattern for updating a file.
#
# It follows these steps:
# 1. Generate the new, desired state of the file into a temporary location.
# 2. Use `diff` to compare the original file with the new one.
# 3. If there are no differences, exit gracefully.
# 4. If there are differences, display them to the user and ask for confirmation.
# 5. If confirmed, atomically replace the original file with the new one using `mv`.
# 6. If not confirmed, clean up the temporary file and abort.
#
# A `trap` is used to guarantee the temporary file is deleted on script exit,
# regardless of whether it succeeds, fails, or is interrupted.
# ==============================================================================

# --- Configuration ---
readonly TARGET_FILE="config.conf"
TEMP_FILE="" # Initialize to be used in the trap

# --- Cleanup ---
cleanup() {
    # Remove the temporary file if it was created
    if [[ -n "${TEMP_FILE:-}" ]] && [[ -f "$TEMP_FILE" ]]; then
        rm -f "$TEMP_FILE"
    fi
}
trap cleanup EXIT # Register the cleanup function to run on script exit

# --- Main Logic ---

# Create a temporary file to hold the modified content
TEMP_FILE=$(mktemp)

# Setup for demo: Create a dummy target file
echo "Server=rabbit.local" >"$TARGET_FILE"
echo "Original content of '$TARGET_FILE':"
cat "$TARGET_FILE"
echo "-------------------------------------"

# 1. Generate the new state ONCE into the temporary file
sed 's/rabbit/groundhog/Ig' "$TARGET_FILE" >"$TEMP_FILE"
echo "Generated new content in '$TEMP_FILE':"
cat "$TEMP_FILE"
echo "-------------------------------------"

# 2. Verify: Check if there are actually differences.
# `diff` returns 0 if files are identical, 1 if different.
# The `if` condition suppresses diff's output, as we only care about the exit code here.
# We will show the user the diff output explicitly later if there is a change.
if diff -q "$TARGET_FILE" "$TEMP_FILE" >/dev/null; then
    echo "✅ No changes detected. File is already up to date."
    exit 0
fi

# 3. Prompt user after showing the diff
echo "The following changes are proposed:"
diff -u --color=always "$TARGET_FILE" "$TEMP_FILE" || true # `|| true` prevents exit on non-zero code from diff
echo "" # Newline for readability
read -p "⚠️  Apply these changes? (y/n) " -n 1 -r
echo

# 4. Act on user input
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Atomic Move: Instantaneously replaces the file, minimizing race conditions
    mv "$TEMP_FILE" "$TARGET_FILE"
    echo "✅ Changes applied. Final content of '$TARGET_FILE':"
    cat "$TARGET_FILE"
else
    echo "❌ Aborted by user. No changes were made."
    # The trap will handle the removal of TEMP_FILE
fi
