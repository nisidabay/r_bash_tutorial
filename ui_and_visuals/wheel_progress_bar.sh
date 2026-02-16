#!/usr/bin/env BASH
#
# Simulates a progress bar

# Function to display the animation
display_walking_man() {
    local step=$1
    case $((step % 3)) in
    0) printf "🚶     " ;;
    1) printf " 🚶   " ;;
    2) printf "  🚶 " ;;
    esac
}

# Function to display the progress bar
display_progress_bar() {
    local progress=$1
    local total=$2
    local width=50
    local completed=$((progress * width / total))
    local remaining=$((width - completed))

    printf "\r["
    printf "%0.s=" $(seq 1 $completed)
    printf "%0.s " $(seq 1 $remaining)
    printf "] %3d%% " "$((progress * 100 / total))"
    display_walking_man "$progress"
}

# Main loop to simulate progress
total_steps=100
for step in $(seq 1 $total_steps); do
    display_progress_bar "$step" "$total_steps"
    sleep 0.1
done
printf "\n"
