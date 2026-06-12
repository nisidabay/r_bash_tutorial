#!/usr/bin/env bash
#
# Copy link from bin/python_nuggets_univ/resources to clipboard
#
# The link can be paste on the desired nugget

# Function to display alert messages
alert() {
    echo "Error: $*"
    osascript -e "display notification \"$*\" with title \"Error\""
}

# Function to check for required dependencies
chk_dependencies() {
    local -a dependencies_array=("$@") # Array of required dependencies
    local -a missing=()                # Array to keep track of missing dependencies

    # Loop through the dependencies and check each one
    for program in "${dependencies_array[@]}"; do
        if ! command -v "$program" &>/dev/null; then
            missing+=("$program") # Add to missing array if not found
        fi
    done

    # Alert and exit if there are missing dependencies
    if [[ "${#missing[@]}" -gt 0 ]]; then
        alert "Install the missing dependencies before continuing:  ${missing[*]}"
        exit 1
    fi
}

# Check for required dependencies
chk_dependencies "fzf" "grep" "pbcopy"

# Directory containing the resources (images/pdfs)
IMAGE_DIR=~/bin/python_nuggets_univ/resources

if [ ! -d "$IMAGE_DIR" ]; then
    alert "Missing directory: $IMAGE_DIR"
    exit 1
fi

# Use 'find' to list files, filtering for PDF and image files, then 'fzf' for interactive selection.
SELECTED_IMAGE=$(find "$IMAGE_DIR" -type f \( -iname "*.pdf" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | fzf --header="Type to search for PDFs/Images" --ansi --preview '
case {} in
    *.pdf|*.jpg|*.jpeg|*.png|*.gif) ;;
    *) echo "File type not supported for preview." ;;
esac
' --preview-window=right:70%:wrap --reverse)

# Check if an image was selected
if [ -z "$SELECTED_IMAGE" ]; then
    echo "No image selected."
    exit 1
fi

# Determine how to open the file based on its extension.
if [[ -n "$SELECTED_IMAGE" ]]; then
    case "$SELECTED_IMAGE" in
    *.pdf)
        open "$SELECTED_IMAGE" >/dev/null 2>&1 &
        ;;
    *.jpg | *.jpeg | *.png | *.gif)
        open "$SELECTED_IMAGE" >/dev/null 2>&1 &
        ;;
    *)
        echo "File type not supported for viewing."
        ;;
    esac
fi

IMAGE="$SELECTED_IMAGE"

# Copy the LINK to the clipboard
echo "link: \"$IMAGE\"" | pbcopy

# Send notification that the image path has been copied
echo "LINK copied to clipboard"
osascript -e 'display notification "Link copied to clipboard" with title "Image Link"'
