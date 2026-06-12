#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Interactive Menu with `select`
#
# This script demonstrates how to create a simple, interactive command-line menu
# using the `select` loop and the `PS3` prompt variable.
#
# - `PS3`: This special variable defines the prompt string that `select` displays
#   to the user before listing the menu options.
# - `select`: This built-in command iterates over a list of items (in this case,
#   an array), presents them as a numbered menu, and waits for the user to
#   select one. The chosen item is assigned to the loop variable (`choice`).
# - `REPLY`: If the user enters a number that doesn't correspond to an option,
#   the `choice` variable is empty, but the `REPLY` variable holds the user's
#   raw input. This is useful for error handling.
# ==============================================================================

# --- Menu Configuration ---
readonly MENU_OPTIONS=(
    "Update system packages"
    "Check disk usage"
    "View running processes"
    "Exit"
)

# --- Main Logic ---

# Display the main menu header
echo "=== 🛠️  System Maintenance Menu ==="

# Customize the `select` prompt
PS3="Please choose an action [1-4]: "

# Start the interactive menu loop
select choice in "${MENU_OPTIONS[@]}"; do
    case "$choice" in
        "Update system packages")
            echo "▶ Updating system packages..."
            # Note: In a real script, you might want to check if the user has sudo privileges first.
            if command -v pacman &>/dev/null; then
                sudo pacman -Syu
            elif command -v apt-get &>/dev/null; then
                sudo apt-get update && sudo apt-get upgrade -y
            elif command -v dnf &>/dev/null; then
                sudo dnf upgrade -y
            else
                echo "❌ Could not find a known package manager (pacman, apt, dnf)."
            fi
            echo "✅ Task completed."
            ;;

        "Check disk usage")
            echo "▶ Checking disk usage..."
            df -h --total
            ;;

        "View running processes")
            echo "▶ Displaying top 10 memory-consuming processes..."
            ps aux --sort=-%mem | head -n 11
            ;;

        "Exit")
            echo "👋 Exiting menu. Goodbye!"
            break # Exit the select loop
            ;;

        *) # Handle invalid input
            # This block is executed if the user's input ($REPLY) is not a valid number
            # corresponding to one of the menu options.
            echo "❌ Invalid selection: '$REPLY'. Please enter a number between 1 and ${#MENU_OPTIONS[@]}."
            ;;
    esac
    # After each action, the menu will be redisplayed automatically by the 'select' loop.
    # We add a newline for better readability between menu displays.
    echo ""
done

# The script will continue here after the loop is exited (e.g., by the 'break' command).
exit 0
