#!/usr/bin/env BASH
#
# Using PS3 prompt
MENU_OPTIONS=(
    # Update system packages
    "Update system packages"
    # Check disk usage
    "Check disk usage"
    # View running processes
    "View running processes"
    # Exit the menu
    "Exit"
)

# Display main menu
echo "=== 🛠️  System Maintenance Menu ==="

# Use select to get user input
PS3="Please choose an action [1-4]: "
select choice in "${MENU_OPTIONS[@]}"; do
    # Handle valid options
    case "$choice" in
    "Update system packages")
        echo "▶ Updating system packages..."
        sudo pacman -Syu
        echo "✅ Update completed."
        ;;
    "Check disk usage")
        echo "▶ Checking disk usage..."
        df -h --total
        ;;
    "View running processes")
        echo "▶ Displaying top 10 running processes..."
        ps aux --sort=-%mem | head -11
        ;;
    "Exit")
        echo "👋 Exiting menu. Goodbye!"
        exit 0
        ;;
    esac
done

# Handle invalid input (non-numeric or out-of-range)
echo "❌ Invalid selection: '$REPLY'. Please enter a number between 1 and 4."
