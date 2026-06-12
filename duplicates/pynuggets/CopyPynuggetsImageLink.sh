#!/bin/bash
#
# Copy link from bin/python_nuggets_univ/resources to clipboard
#
# The link can be paste on the desired nugget

# Colors for displaying messages
purple=$(tput setaf 13)
reset=$(tput sgr0)

# Function to display alert messages
alert() {
	tput civis                            # Hides the cursor for cleaner output
	printf "${purple}✘ %s${reset}\n" "$*" # Prints the message in purple
	tput cnorm                            # Resets the cursor
}

# Function to check for required dependencies
chk_dependencies() {
	tput civis                         # Hides the cursor
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

	tput cnorm # Reset the cursor
}

# Check for required dependencies
chk_dependencies "fzf" "xclip" "notify-send" "zathura" "sxiv"

# Directory containing the resources (images/pdfs)
IMAGE_DIR=~/bin/python_nuggets_univ/resources

if [ ! -d "$IMAGE_DIR" ]; then
	alert "Missing directory: $IMAGE_DIR"
fi

# Use 'rg' to list files, filtering for PDF and image files, then 'fzf' for interactive selection.
SELECTED_IMAGE=$(rg --files $IMAGE_DIR | grep -Ei '\.(pdf|jpg|jpeg|png|gif)$' | fzf --header="Type to search for PDFs/Images" --ansi --preview '
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
		zathura "$SELECTED_IMAGE" >/dev/null 2>&1 &
		;;
	*.jpg | *.jpeg | *.png | *.gif)
		sxiv "$SELECTED_IMAGE" >/dev/null 2>&1 &
		;;
	*)
		echo "File type not supported for viewing."
		;;
	esac
fi

IMAGE="$SELECTED_IMAGE"

# Copy the LINK to the clipboard
echo "link: \"$IMAGE\"" | xclip -i -sel clip

# Send notification that the image path has been copied
notify-send "LINK copied to clipboard"
