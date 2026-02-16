#!/usr/bin/env BASH
#
# diff two files in-line

TARGET_FILE="config.conf"
TEMP_FILE="$(mktemp)"

# Setup for demo
echo "Server=rabbit.local" >"$TARGET_FILE"
echo "Original file: $TARGET_FILE"
cat "$TARGET_FILE"
#
# 1. Generate the new state ONCE into a temporary file
sed 's/rabbit/groundhog/Ig' "$TARGET_FILE" >"$TEMP_FILE"
echo "Modified file: $TEMP_FILE"
cat "$TEMP_FILE"

# 2. Verify: Check if there are actually differences
# diff returns 0 if files are identical, 1 if different
if diff -u --color=always "$TARGET_FILE" "$TEMP_FILE"; then
    echo "✅ No changes detected. File is already up to date."
    rm "$TEMP_FILE"
    exit 0
fi

# 3. Prompt user (The diff output is already visible from the command above)
echo "" # Newline for readability
read -p "⚠️  Apply above changes? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 4. Atomic Move: Instantaneously replaces the file
    mv "$TEMP_FILE" "$TARGET_FILE"
    echo "Changes applied."
    cat "$TARGET_FILE"
else
    echo "Aborted."
    rm "$TEMP_FILE"
fi
