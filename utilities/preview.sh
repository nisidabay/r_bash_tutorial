#!/usr/bin/env BASH

# This script is called by fzf for each file in the preview window.
# NEW: Added a trap to clean up temporary PDF preview images.
trap 'rm -f "$PDF_PREVIEW_TMPFILE" 2>/dev/null' EXIT

# --- Configuration & Setup ---
# The file to be previewed is passed as the first argument.
file="$1"
# The FIFO path is inherited from the parent script's exported environment variable.
FIFO_PATH="$FIFO_UEBERZUG"

# --- Terminal Geometry Calculation ---
# Get the current dimensions of the terminal.
WIDTH=$(tput cols)
HEIGHT=$(tput lines)

# fzf preview window is configured to be on the right, taking up 60% of the width.
PREVIEW_PERCENT=60
# Padding inside the preview window to avoid images touching the border.
PADDING=2

# Calculate the target dimensions for the preview content.
# Adjust width for padding on both left and right.
TARGET_WIDTH=$((WIDTH * PREVIEW_PERCENT / 100 - 2 * PADDING))
# Approximate height, accounting for fzf's header, footer, and prompt lines.
TARGET_HEIGHT=$((HEIGHT - 8))

# Calculate the position (top-left corner) for the image preview.
# X position starts after the main fzf list window.
POSITION_X=$((WIDTH - (WIDTH * PREVIEW_PERCENT / 100) + PADDING))
# Y position starts a few lines down to clear the fzf header.
POSITION_Y=4

# --- Ueberzug Helper Functions ---

# Sends a JSON command to the ueberzug FIFO to display an image.
# Arguments:
#   $1: Path to the image file.
show_image() {
    # The JSON payload tells ueberzug what to do ('add' an image), its unique
    # identifier ('preview'), where to place it, how to scale it ('contain'
    # fits the image within the dimensions while preserving aspect ratio),
    # and the path to the image file.
    printf '{"action":"add","identifier":"preview","x":"%s","y":"%s","width":"%s","height":"%s","scaler":"contain","path":"%s"}\n' \
        "$POSITION_X" "$POSITION_Y" "$TARGET_WIDTH" "$TARGET_HEIGHT" "$1" >"$FIFO_PATH"
}

# Sends a JSON command to the ueberzug FIFO to remove the image.
clear_image() {
    # This is necessary when switching from an image preview to a text preview.
    printf '{"action":"remove","identifier":"preview"}\n' >"$FIFO_PATH"
}

# --- Main Preview Logic ---

# Determine the MIME type of the file to decide how to preview it.
mime=$(file --mime-type -b "$file")

case "$mime" in
# For text-based files, clear any existing image and show content with 'bat'.
text/* | application/json | application/javascript | application/xml | text/x-shellscript | text/markdown)
    clear_image
    # Use 'bat' for syntax highlighting. If 'bat' fails or is not installed,
    # fall back to the standard 'cat' command.
    /usr/bin/bat --terminal-width "$TARGET_WIDTH" "$file" --style=numbers --color=always || cat "$file"
    ;;
# For image files, clear any previous preview and then show the new image.
image/*)
    # Clearing first prevents a flicker or overlap if the previous file was also an image.
    clear_image
    show_image "$file"
    ;;
# For PDF files, show the first page as an image.
application/pdf)
    clear_image
    # Generate temp prefix (no extension)
    PDF_PREVIEW_TMPFILE=$(mktemp /tmp/pdf-preview-XXXXXX)

    # Run pdftoppm with prefix
    if pdftoppm -singlefile -png -r 144 -f 1 -l 1 "$file" "$PDF_PREVIEW_TMPFILE" >/dev/null 2>&1; then
        # Now hand ueberzug the properly named file with .png appended
        show_image "${PDF_PREVIEW_TMPFILE}.png"
        # Update trap-cleanup target
        PDF_PREVIEW_TMPFILE="${PDF_PREVIEW_TMPFILE}.png"
    else
        echo "Failed to generate PDF preview."
        rm -f "${PDF_PREVIEW_TMPFILE}"*
    fi
    ;;
esac
