#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# dmenu Video Launcher
#
# A script to manage and play a list of videos from a text file using dmenu,
# providing a browser-free way to access favorite content.
#
# Features:
# - Lists videos for playback via `mpv`.
# - Add, Edit, Delete, and Copy video URLs.
# - Uses `dmenu` for all interactive menus.
# - Sends desktop notifications for feedback.
# - Includes dependency checks and help menu.
#
# The data file (`tutorials_vid.txt`) is expected to be in the format:
#   Video Title: https://video.url/
# ==============================================================================

# --- Configuration ---
readonly TUTORIALS_PATH="${HOME}/bin/"
readonly VIDEOS_FILE="${TUTORIALS_PATH}/tutorials_vid.txt"
readonly TERMINAL="${TERMINAL:-st}" # Use 'st' as default terminal, or override with env var

# --- Helper: Notification Handler ---
notify() {
    local title="$1"
    local message="$2"
    local severity="${3:-normal}" # Default to 'normal' urgency

    local icon="dialog-information"
    [[ "$severity" == "critical" ]] && icon="dialog-error"

    notify-send -u "$severity" "$title" "$message" --icon="$icon"
}

# --- Setup and Validation ---

# Check if the videos file exists and is not empty.
check_videos_file() {
    if [[ ! -f "$VIDEOS_FILE" ]]; then
        notify "[ERROR]" "Videos file not found at: $VIDEOS_FILE" "critical"
        exit 1
    fi
    if [[ ! -s "$VIDEOS_FILE" ]]; then
        notify "[Warning]" "Videos file is empty." "normal"
    fi
}

# Source dmenu appearance settings if available.
# This makes the dmenu theme configurable externally.
if [[ -f "${HOME}/bin/dmenu_wal.sh" ]]; then
    # shellcheck disable=SC1091
    source "${HOME}/bin/dmenu_wal.sh"
fi

# Check for required command-line tools.
check_dependencies() {
    local -a missing_deps=()
    for dep in "$@"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if ((${#missing_deps[@]} > 0)); then
        local deps_list="${missing_deps[*]}"
        notify "[ERROR]" "Missing dependencies: $deps_list" "critical"
        echo "Error: Please install the following missing dependencies: $deps_list" >&2
        exit 1
    fi
}

# --- Core Functions ---

# Generic dmenu wrapper.
menu() {
    local prompt="$1"
    # The `${DMENU_APPEARANCE[@]:-}` syntax safely handles the case where the array is unbound.
    dmenu -c -i -l 20 "${DMENU_APPEARANCE[@]:-}" -p "$prompt"
}

# Display a help message inside dmenu.
show_help() {
    cat <<EOF | menu 'Help - Press Enter to Close'
dmenu_tutorialsvid.sh - A dmenu video manager

Actions:
  Play       → Choose a video to play with mpv.
  Add        → Open the video file in an editor to add a new entry.
  Copy       → Copy a video's URL to the clipboard.
  Delete     → Remove a video from the list.
  Edit       → Open the video file and jump to the selected video's line.
  Help       → Show this help message.
EOF
}

# Get a video title from the user via dmenu.
get_video_title() {
    # `cut` extracts the title (everything before the first ':').
    cut -d: -f1 "$VIDEOS_FILE" | menu "Choose a video:"
}

# Extract the URL for a given video title.
# A simpler approach could be: grep "^${title}:" "$VIDEOS_FILE" | cut -d: -f2-
get_url_from_title() {
    local title="$1"
    # Use `grep` to find the line and `cut` to extract the URL part.
    # `grep -m 1` ensures we only get the first match.
    # `cut -d: -f2-` gets everything after the first colon.
    local url
    url=$(grep -m 1 "^${title} *:" "$VIDEOS_FILE" | cut -d: -f2-)
    # Trim leading whitespace.
    url="${url#"${url%%[![:space:]]*}"}"
    if [[ -n "$url" ]]; then
        echo "$url"
        return 0
    fi
    return 1
}

# Backup the videos file.
make_backup() {
    cp -f "$VIDEOS_FILE" "$VIDEOS_FILE.bak"
    notify "Backup" "Created backup: ${VIDEOS_FILE}.bak" "normal"
}

# Sort the videos file alphabetically and remove empty lines.
sort_videos() {
    local temp
    temp=$(mktemp)
    # `grep .` is a concise way to remove empty lines.
    grep . "$VIDEOS_FILE" | sort >"$temp"
    mv "$temp" "$VIDEOS_FILE"
}

# --- Action Handlers ---

add_new_video() {
    # Open the file in a terminal editor for the user to add a new line.
    setsid -fw "$TERMINAL" -e "${EDITOR:-nvim}" "$VIDEOS_FILE" &>/dev/null
    sort_videos
    make_backup
    notify "Videos" "Video list updated." "normal"
}

edit_video() {
    local video_to_edit
    video_to_edit=$(get_video_title)
    [[ -z "$video_to_edit" ]] && return # User cancelled dmenu

    # Find the line number. `grep -n ... | cut -d: -f1` is a classic way to do this.
    local line_num
    line_num=$(grep -n -m 1 "^${video_to_edit} *:" "$VIDEOS_FILE" | cut -d: -f1)

    if [[ -n "$line_num" ]]; then
        setsid -fw "$TERMINAL" -e "${EDITOR:-nvim}" "+$line_num" "$VIDEOS_FILE" &>/dev/null
        # Assume changes were made.
        sort_videos
        make_backup
    else
        notify "[ERROR]" "Could not locate video '$video_to_edit' in file." "critical"
    fi
}

delete_video() {
    local selected_video
    selected_video=$(get_video_title)
    [[ -z "$selected_video" ]] && return # User cancelled

    local confirm
    confirm=$(printf "No\nYes" | menu "Delete '$selected_video'?")

    if [[ "$confirm" == "Yes" ]]; then
        # Use `grep -v` to exclude the selected line and write to a temp file.
        local tmpfile
        tmpfile=$(mktemp)
        grep -v "^${selected_video} *:" "$VIDEOS_FILE" >"$tmpfile"
        mv "$tmpfile" "$VIDEOS_FILE"
        make_backup
        notify "Video Deleted" "'$selected_video' has been removed." "normal"
    else
        notify "Cancelled" "Video deletion cancelled." "normal"
    fi
}

copy_video_url() {
    local selected_video
    selected_video=$(get_video_title)
    [[ -z "$selected_video" ]] && return # User cancelled

    local url
    url=$(get_url_from_title "$selected_video")
    if [[ -n "$url" ]]; then
        printf '%s' "$url" | xsel -ib
        notify "URL Copied" "URL for '$selected_video' copied to clipboard." "normal"
    else
        notify "[ERROR]" "Could not extract URL for '$selected_video'." "critical"
    fi
}

play_video() {
    local selected_video
    selected_video=$(get_video_title)
    [[ -z "$selected_video" ]] && return # User cancelled

    local url
    url=$(get_url_from_title "$selected_video")
    if [[ -n "$url" ]]; then
        notify "Playing Video" "Loading '$selected_video' with mpv..." "normal"
        # Run mpv in the background.
        mpv --ao=pulse --no-terminal "$url" &
    else
        notify "[ERROR]" "Could not find URL for '$selected_video'." "critical"
    fi
}

# --- Main Menu Logic ---
select_action() {
    local -a actions=("Play" "Add" "Copy" "Delete" "Edit" "Help")
    local choice
    choice=$(printf "%s\n" "${actions[@]}" | menu "Video Menu:")

    case $choice in
        Play) play_video ;;
        Add) add_new_video ;;
        Copy) copy_video_url ;;
        Delete) delete_video ;;
        Edit) edit_video ;;
        Help) show_help ;;
        *) return 1 ;; # User cancelled
    esac
}

# --- Main function ---
main() {
    check_dependencies "dmenu" "mpv" "notify-send" "xsel"
    check_videos_file
    select_action
}

main
