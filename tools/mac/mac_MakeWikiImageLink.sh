#!/usr/bin/env bash
#
# Create an image link to be inserted in Vim wiki

alert() {
    local message=$*
    echo "Error: $message"
    osascript -e "display notification \"$message\" with title \"Error\""
}

cp2cb() {
    pbcopy
}

chk_dependencies() {
    local -a dependencies=("$@")
    local -a missing_dependencies=()
    for program in "${dependencies[@]}"; do
        if ! command -v "$program" &>/dev/null; then
            missing_dependencies+=("$program")
        fi
    done
    if [[ "${#missing_dependencies[@]}" -gt 0 ]]; then
        alert "Warning: Missing dependencies [${missing_dependencies[*]}]"
        osascript -e 'display notification "Missing dependencies" with title "Warning"'
        exit 1
    fi
}

main() {
    IMAGE_DIR=~/vimwiki/resources
    if [ ! -d "$IMAGE_DIR" ]; then
        echo "Error: DIR MISSING ~/vimwiki/resources"
        osascript -e 'display notification "DIR MISSING ~/vimwiki/resources" with title "Error"'
        exit 1
    fi
    SELECTED_IMAGE=$(find "$IMAGE_DIR" -type f | fzf --header="Select image to copy" --header-first)
    if [ -z "$SELECTED_IMAGE" ]; then
        echo "Warning: No image selected"
        osascript -e 'display notification "No image selected" with title "Warning"'
        exit 1
    fi
    read -rp "Type a description for the image: " desc
    if [ -z "$desc" ]; then
        echo "Warning: Missing image description"
        osascript -e 'display notification "Missing image description" with title "Warning"'
        exit 1
    fi
    # Format the image path into Markdown syntax
    IMAGE_MD="![$desc]($SELECTED_IMAGE)"
    echo "$IMAGE_MD" | cp2cb && osascript -e 'display notification "Image link copied to clipboard" with title "Vimwiki link"'
}

chk_dependencies "fzf" "osascript"
main
