#!/usr/bin/env bash
# Script name: clm-note-dwm.sh
# Personal notes for dwm
#
#   1. Add individual notes.
#   2. Create and edit notes at the same time.
#
# Description: Store multiple one-line texts or codes and copy one of them when needed.
# Dependencies: dmenu, xclip, wl-clipboard (for Wayland)
#
# Authors:      Fawzakin
#               Derek Taylor

set -euo pipefail

# Define constants
TERMINAL=${TERMINAL:-st}
NOTES_DIR="$HOME/notes"
EDITOR="nvim"
MENU="rofi -dmenu -i -p Notes menu:"

# Ensure the notes directory exists
mkdir -p "$NOTES_DIR"

cp2cb() {
    # Copy the selected note to the clipboard
    case "${XDG_SESSION_TYPE:-}" in
    'x11') xclip -r -selection clipboard ;;
    'wayland') wl-copy -n ;;
    *) echo "Unknown display server" && exit 1 ;;
    esac
}

chk_dependencies() {
    # Checks if the programs passed as strings are installed
    local -a dependencies_array=("$@")
    local -a missing=()

    for program in "${dependencies_array[@]}"; do
        if ! command -v "$program" > /dev/null; then
            missing+=("$program")
        fi
    done

    if [[ "${#missing[@]}" -gt 0 ]]; then
        local missing_programs="${missing[*]}"
        echo "Install the missing dependencies before continuing: $missing_programs"
        notify-send "Missing Dependencies" \
            "Install the following programs before continuing: $missing_programs" \
            --icon=dialog-warning
        exit 1
    fi
}

main() {
    # Picking our options.
    choice=$(printf 'Copy note\nNew note\nDelete note\nEdit note\nQuit' | $MENU 'Notes:')

    # Choose what we should do with our choice.
    case "$choice" in
    'Copy note')
        note_pick=$(ls "$NOTES_DIR" | $MENU 'Copy:')
        note_file="$NOTES_DIR/$note_pick"
        [ -n "$note_pick" ] && cp2cb < "$note_file" && notify-send -u normal "Note copied" "$note_pick" --icon=dialog-information
        ;;

    'New note')
        note_filename=$(echo "" | $MENU 'Enter new note:')
        note_filename=$(echo "$note_filename" | sed 's/[^a-zA-Z0-9]/_/g') # Remove special characters and replace with underscores
        note_file="$NOTES_DIR/$note_filename.txt"
        touch "$note_file"
        [ -n "$note_file" ] && $TERMINAL -e "$EDITOR" "$note_file" && notify-send -u normal "Note created" "$note_filename"
        ;;

    'Delete note')
        note_del=$(ls "$NOTES_DIR" | $MENU 'Delete:')
        note_file="$NOTES_DIR/$note_del"
        [ -n "$note_del" ] && rm "$note_file" && notify-send -u normal "Note deleted" "$note_del" --icon=dialog-information
        ;;

    'Edit note')
        note_edit=$(ls "$NOTES_DIR" | $MENU 'Edit:')
        note_file="$NOTES_DIR/$note_edit"
        [ -n "$note_edit" ] && $TERMINAL -e "$EDITOR" "$note_file" && notify-send -u normal "Note edited" "$note_edit" --icon=dialog-information
        ;;

    'Quit')
        echo "Program terminated." && exit 0
        ;;
    *)
        exit 0
        ;;
    esac
}

# Begin execution
# chk_dependencies "dmenu" "vim" "st" "notify-send" "xclip" "wl-copy"
chk_dependencies "dmenu" "vim" "st" "notify-send" "xclip" 
main
