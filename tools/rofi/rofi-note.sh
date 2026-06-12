#!/usr/bin/env bash
# Modified by nisidabay. Adapted to my needs:
# wofi notes menu editor

# Script name: wofi-note
#   1. Add individual notes.
#   2. Create and edit notes at the same time
#
# Description: Store multiple one-line texts or codes and copy one of them when needed.
# Dependencies: dmenu, fzf, rofi, xclip
#
# Authors:      Fawzakin
#               Derek Taylor
#
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.

# Set strict error handling
# -e: exit on error
# -u: exit on undefined variables
# -o pipefail: exit on pipe failures
set -euo pipefail

# Configuration variables
RMENU="rofi -dmenu -p Notes:" # Rofi menu command
EDITOR="${EDITOR:-vim}"       # Default editor
TERMINAL="${TERMINAL:-st}"    # Default terminal
notes_dir="$HOME/notes"       # Notes directory path

# Function: Copy content to clipboard based on display server
# Arguments: None (reads from stdin)
# Returns: None
cp2cb() {
    case "$XDG_SESSION_TYPE" in
    'x11')
        xclip -r -selection clipboard
        ;;
    'wayland')
        wl-copy -n
        ;;
    *)
        echo "Error: Unknown display server" >&2
        exit 1
        ;;
    esac
}

# Function: Copy an existing note to clipboard
# Arguments: None
# Returns: None
copy_note() {
    local note_pick
    local note_file

    # Display list of notes and let user select one
    note_pick=$(ls "${notes_dir}" | ${RMENU} 'Copy:' "$@")
    note_file="$notes_dir/$note_pick"

    # Copy note content if a note was selected
    if [ -n "${note_pick}" ]; then
        cp2cb <"${note_file}"
        notify-send -u normal "Note copied" "${note_pick}"
    fi
}

# Function: Create a new note
# Arguments: None
# Returns: None
create_note() {
    local note_filename
    local note_file

    # Get filename from user
    note_filename=$(echo "" | ${RMENU} 'Enter new note:' "$@")

    # Sanitize filename (replace special characters with underscores)
    note_filename=$(echo "$note_filename" | sed 's/[^a-zA-Z0-9]/_/g')
    note_file="$notes_dir/$note_filename.txt"

    # Create and open the note
    touch "${note_file}"
    if [ -n "${note_file}" ]; then
        "$TERMINAL" -e sh -c "\"$EDITOR\" \"${note_file}\" && \"$SHELL\""
        notify-send -u normal "Note created" "$note_filename"
    fi
}

# Function: Delete an existing note
# Arguments: None
# Returns: None
delete_note() {
    local note_del
    local note_file

    # Display list of notes and let user select one to delete
    note_del=$(find "$notes_dir" -type f -printf "%f\n" | ${RMENU} 'Delete:' "$@")
    note_file="$notes_dir/$note_del"

    # Delete the selected note
    if [ -n "${note_del}" ]; then
        rm "$note_file"
        notify-send -u normal "Note deleted" "${note_del}"
    fi
}

# Function: Edit an existing note
# Arguments: None
# Returns: None
edit_note() {
    local note_edit
    local note_file

    # Display list of notes and let user select one to edit
    note_edit=$(ls "${notes_dir}" | ${RMENU} 'Edit:' "$@")
    note_file="${notes_dir}/${note_edit}"

    # Open the selected note in the editor
    if [ -n "${note_edit}" ]; then
        "$TERMINAL" -e sh -c "\"$EDITOR\" \"${note_file}\" && \"$SHELL\""
        notify-send -u normal "Note edited"
    fi
}

# Function: Main program logic
# Arguments: Command line arguments
# Returns: None
main() {
    # Display main menu and get user choice
    local choice
    choice=$(printf '%s\n' "Copy note" "New note" "Delete note" "Edit note" "Quit" |
        $RMENU "$@")

    # Process user choice
    case "$choice" in
    'Copy note')
        copy_note "$@"
        ;;
    'New note')
        create_note "$@"
        ;;
    'Delete note')
        delete_note "$@"
        ;;
    'Edit note')
        edit_note "$@"
        ;;
    'Quit')
        echo "Program terminated."
        exit 0
        ;;
    *)
        exit 0
        ;;
    esac
}

# Start the program
main "$@"
