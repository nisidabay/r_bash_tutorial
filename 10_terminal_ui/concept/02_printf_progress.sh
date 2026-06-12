#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Simple Text-Based Progress Bar
#
# This script demonstrates how to create a simple, single-line progress bar
# in the terminal using standard shell commands like `printf` and `tr`.
#
# How it Works:
# - `\r`: The carriage return character moves the cursor to the beginning of
#   the current line without moving down. This allows the script to overwrite
#   the same line on each update, creating the animation.
# - `printf "%${filled}s"`: This `printf` command prints a string of spaces
#   with a dynamic length determined by the `filled` variable.
# - `| tr ' ' '#'`: The output of `printf` (a string of spaces) is piped to
#   `tr`, which translates every space character into a hash character (`#`),
#   creating the "filled" part of the progress bar.
# ==============================================================================

# --- Functions ---

# Draws a progress bar on a single line.
# Arguments:
#   $1: The current percentage (0-100).
#   $2: The total width of the bar in characters (optional, defaults to 40).
draw_progress_bar() {
    local percentage=$1
    local width=${2:-40} # Default width is 40 characters

    # Calculate how many characters should be "filled" and "empty".
    local filled_chars=$((percentage * width / 100))
    local empty_chars=$((width - filled_chars))

    # --- Drawing the Bar ---
    # 1. Print the percentage, padded to 3 digits (e.g., " _7%"). `\r` moves the
    #    cursor to the start of the line for the overwrite effect.
    printf "\r[%3d%%] [" "$percentage"

    # 2. Print the "filled" part of the bar.
    #    `printf "%${filled_chars}s"` creates a string of `filled_chars` spaces.
    #    `tr ' ' '#'` converts those spaces to '#' characters.
    if ((filled_chars > 0)); then
        printf "%${filled_chars}s" "" | tr ' ' '#'
    fi

    # 3. Print the "empty" part of the bar.
    if ((empty_chars > 0)); then
        printf "%${empty_chars}s" "" | tr ' ' '-'
    fi

    # 4. Close the bar.
    printf "]"
}

# --- Main Logic ---
main() {
    echo "Demonstrating a simple progress bar:"

    # Loop from 0 to 100 to simulate progress.
    for i in {0..100}; do
        draw_progress_bar "$i" 50 # Draw a bar of width 50
        # sleep is used here to simulate work being done.
        sleep 0.05
    done

    # Print a final newline to move to the next line after the progress bar is complete.
    printf "\n"
    echo "Done."
}

# --- Script Entry Point ---
main
