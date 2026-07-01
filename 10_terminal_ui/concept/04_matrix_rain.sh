#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# "Matrix" Digital Rain Effect in Pure Bash
#
# This script creates a simple "digital rain" animation reminiscent of the
# movie "The Matrix" using standard shell commands and `tput` for terminal
# manipulation.
#
# How it Works:
# - `tput smcup`: Switches to the terminal's "alternate screen buffer". This
#   is like a temporary, clean canvas that disappears when the script ends,
#   restoring your original terminal content.
# - `tput civis`: Makes the cursor invisible so it doesn't blink and distract
#   from the animation.
# - `trap ... SIGINT`: This is a crucial cleanup command. It "traps" the
#   interrupt signal (Ctrl+C) and, before exiting, runs commands to restore
#   the terminal to its normal state.
#   - `tput rmcup`: Exits the alternate screen buffer.
#   - `tput cnorm`: Makes the cursor visible again.
# - The `while true` loop continuously generates and prints lines of
#   random characters to simulate the falling rain.
# ==============================================================================

# --- Cleanup and Setup ---

# Register the cleanup function to run when the script receives an interrupt
# signal (e.g., when the user presses Ctrl+C).
trap 'tput rmcup; tput cnorm; exit 0' SIGINT

# Set up the terminal for the animation.
tput smcup  # Switch to the alternate screen.
tput civis  # Hide the cursor.
tput clear  # Clear the screen.

# --- Animation Configuration ---

# Set text color to bright green using ANSI escape codes.
readonly COLOR_GREEN='\033[1;32m'
echo -e "$COLOR_GREEN"

# Get the current width of the terminal.
width=$(tput cols)
readonly width
# A character set to use for the "rain".
readonly CHARS="0123456789"
#readonly CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
readonly sleep_duration=0.05

# --- Main Animation Loop ---

while true; do
    # Build a line of random characters.
    line=""
    for ((i = 0; i < width; i++)); do
        # Generate a random number.
        rand=$((RANDOM % 10))

        # Decide whether to print a character or a space.
        # This creates the sparse "rain" effect.
        if [ $rand -gt 7 ]; then
            # Pick a random character from the character set.
            rand_char_index=$((RANDOM % ${#CHARS}))
            line+="${CHARS:rand_char_index:1}"
        else
            line+=" "
        fi
    done

    # Print the completed line to the screen.
    echo "$line"
    # Pause briefly to control the speed of the animation.
    sleep "$sleep_duration"
done
