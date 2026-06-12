#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Animated Progress Bar with a "Walking Man"
#
# This script displays a dynamic progress bar in the terminal, complete with
# a simple walking man animation, to provide feedback for a long-running process.
#
# How it Works:
# - It uses a loop to simulate progress from 0 to 100.
# - On each iteration, it calls a function to redraw the entire progress bar line.
# - `\r` (carriage return) is used to move the cursor to the beginning of the
#   line, allowing the new line to overwrite the old one.
# - The walking man animation is a simple `case` statement that cycles through
#   three different frames based on the current step.
# - `printf "%0.sX" $(seq 1 N)` is a clever shell trick to print the character 'X'
#   N times without a loop.
# ==============================================================================

# --- Animation & Drawing Functions ---

# Displays one of three frames for a walking man animation.
# The frame is chosen based on the current step number modulo 3.
# Arguments:
#   $1: The current step number.
display_walking_man() {
    local step="$1"
    case $((step % 3)) in
        0) printf "🚶    " ;;
        1) printf " 🚶   " ;;
        2) printf "  🚶  " ;;
    esac
}

# Draws the complete progress bar line, including the walking man.
# Arguments:
#   $1: The current progress (e.g., number of files processed).
#   $2: The total number of items to process.
display_progress_bar() {
    local progress="$1"
    local total="$2"
    local width=50 # Total width of the bar part in characters.

    # Calculate the number of characters for the "completed" and "remaining" parts.
    local completed_chars=$((progress * width / total))
    local remaining_chars=$((width - completed_chars))

    # --- Drawing the Line ---
    # `\r` moves cursor to the start of the line.
    printf "\r["

    # A more readable (though slightly less performant) way to print the bar:
    # for ((i=0; i<completed_chars; i++)); do printf "="; done
    # for ((i=0; i<remaining_chars; i++)); do printf " "; done

    # Print the "completed" part of the bar ('=' characters).
    if ((completed_chars > 0)); then
        printf "%0.s=" $(seq 1 $completed_chars)
    fi

    # Print the "remaining" part of the bar (' ' characters).
    if ((remaining_chars > 0)); then
        printf "%0.s " $(seq 1 $remaining_chars)
    fi

    # Print the closing bracket, percentage, and the animation frame.
    printf "] %3d%% " "$((progress * 100 / total))"
    display_walking_man "$progress"
}

# --- Main Execution ---
main() {
    local total_steps=100
    echo "Simulating a process with an animated progress bar..."

    # Main loop to simulate progress.
    # Using a C-style for loop is generally more portable than `seq`.
    for ((step = 0; step <= total_steps; step++)); do
        display_progress_bar "$step" "$total_steps"
        # sleep is used here to control the animation speed and simulate work.
        sleep 0.1
    done

    # Print a final newline to move the cursor to the next line after the loop.
    printf "\nDone.\n"
}

main
