#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# fzf Terminal Previewer with Image and PDF Support via Ueberzug
#
# This script is designed to be called by `fzf`'s `--preview` option. It
# intelligently determines the type of a file and displays a rich preview:
# - Text files are shown with syntax highlighting using `bat`.
# - Images are displayed directly in the terminal using `ueberzug`.
# - PDFs have their first page rendered as an image and displayed.
#
# Dependencies:
# - `fzf`: The command-line fuzzy finder.
# - `ueberzug`: A command-line utility to display images in terminals.
# - `bat`: A `cat` clone with syntax highlighting and Git integration.
# - `pdftoppm`: A utility from the `poppler` package to convert PDFs to images.
#
# Usage (within fzf):
#   fzf --preview='/path/to/this/script.sh {}'
# ==============================================================================

# --- Cleanup ---
# The trap ensures that the temporary PDF preview image is removed when the
# script exits, for any reason.
trap 'rm -f "$PDF_PREVIEW_TMPFILE" 2>/dev/null' EXIT

# --- Configuration & Setup ---
# The file to be previewed is passed as the first argument from fzf.
readonly file="$1"
# The FIFO path for ueberzug communication is expected to be an exported
# environment variable from the parent script that launched fzf.
readonly FIFO_PATH="$FIFO_UEBERZUG"

# --- Terminal Geometry Calculation ---
# A more robust check for dependencies should be done in the parent script.
# if ! command -v tput >/dev/null || ! command -v file >/dev/null; then
#     echo "Error: 'tput' or 'file' command not found." >&2; exit 1;
# fi

readonly WIDTH=$(tput cols)
readonly HEIGHT=$(tput lines)

# Configuration for the fzf preview window layout.
readonly PREVIEW_PERCENT=60
readonly PADDING=2

# Calculate the target dimensions for the preview content.
readonly TARGET_WIDTH=$((WIDTH * PREVIEW_PERCENT / 100 - 2 * PADDING))
readonly TARGET_HEIGHT=$((HEIGHT - 8)) # Adjusted for fzf UI elements

# Calculate the on-screen position for the ueberzug image.
readonly POSITION_X=$((WIDTH - (WIDTH * PREVIEW_PERCENT / 100) + PADDING))
readonly POSITION_Y=4

# --- Ueberzug Helper Functions ---

# Sends a JSON command to the ueberzug FIFO to display an image.
show_image() {
    local image_path="$1"
    # This JSON payload is the core of ueberzug's communication protocol.
    # It instructs ueberzug to 'add' an image with a specific 'identifier',
    # placing it at a calculated position and scaling it to fit the container.
    printf '{"action":"add","identifier":"preview","x":"%s","y":"%s","width":"%s","height":"%s","scaler":"contain","path":"%s"}\n' \
        "$POSITION_X" "$POSITION_Y" "$TARGET_WIDTH" "$TARGET_HEIGHT" "$image_path" >"$FIFO_PATH"
}

# Sends a command to remove the currently displayed image.
clear_image() {
    # This is crucial for switching between image and text previews cleanly.
    printf '{"action":"remove","identifier":"preview"}\n' >"$FIFO_PATH"
}

# --- Main Preview Logic ---

main() {
    # Determine the MIME type of the file to decide on the preview method.
    local mime
    mime=$(file --mime-type -b "$file")

    case "$mime" in
    # --- Text-based Files ---
    text/* | application/json | application/javascript | application/xml | text/x-shellscript | text/markdown)
        clear_image # Ensure no old image is lingering.
        # Use 'bat' for a rich preview, falling back to 'cat' if it's not available or fails.
        # A better implementation would check for `bat` once using `command -v`.
        if command -v bat &>/dev/null; then
             bat --terminal-width "$TARGET_WIDTH" --style=numbers --color=always "$file"
        else
             cat "$file"
        fi
        ;;

    # --- Image Files ---
    image/*)
        clear_image # Clear previous preview first.
        show_image "$file"
        ;;

    # --- PDF Files ---
    application/pdf)
        clear_image
        # Create a temporary file path for the PDF preview image.
        # The trap at the top will handle cleanup.
        PDF_PREVIEW_TMPFILE=$(mktemp /tmp/pdf-preview-XXXXXX.png)

        # Use `pdftoppm` to render the first page of the PDF as a PNG.
        # -singlefile: Ensures only one file is created.
        # -r 144: Sets the resolution (DPI).
        # -f 1 -l 1: Specifies first page and last page (i.e., only page 1).
        if pdftoppm -singlefile -png -r 144 -f 1 -l 1 "$file" "${PDF_PREVIEW_TMPFILE%.png}" >/dev/null 2>&1; then
            # If successful, tell ueberzug to display the generated PNG.
            show_image "$PDF_PREVIEW_TMPFILE"
        else
            # If pdftoppm fails, show an error message.
            echo "Failed to generate PDF preview."
            # It's good practice to clean up here as well.
            rm -f "$PDF_PREVIEW_TMPFILE" 2>/dev/null
        fi
        ;;
    # --- Fallback for Binary/Unknown Files ---
    *)
        clear_image
        echo "Binary file or unsupported type: $mime"
        # `file` provides basic info about any file type.
        file "$file"
        ;;
    esac
}

main
