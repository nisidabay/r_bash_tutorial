#!/usr/bin/env BASH
#
# Display favorite videos without browser
# Idea: Luke Smith Page and Youtube

TUTORIALS_PATH="${HOME}/bin/"
VIDEOS_FILE="${TUTORIALS_PATH}/tutorials_vid.txt"
TERMINAL="${TERMINAL:-st}"

# --- Notification handler ---
notify() {
    local title="$1"
    local message="$2"
    local severity="$3"

    case "$severity" in
    "normal")
        notify-send -u normal "$title" "$message" --icon=dialog-information
        ;;
    "critical")
        notify-send -u critical "$title" "$message" --icon=dialog-error
        ;;
    *)
        notify-send -u normal "$title" "$message" --icon=dialog-information
        ;;
    esac

}

check_videos() {
    if [[ ! -f "$VIDEOS_FILE" || ! -s "$VIDEOS_FILE" ]]; then
        notify "[ERROR]" "Missing tutorials_vid.txt"
        exit 1
    fi
}

# --- Defines the appearance for dmenu, configured by pywal ---
if [[ ! -f "${HOME}/bin/dmenu_wal.sh" ]]; then
    echo "Error: dmenu_wal.sh not found" >&2
    exit 1
fi
# shellcheck disable=SC1091
source "${HOME}/bin/dmenu_wal.sh"

show_help() {
    cat <<'EOF' | menu 'Help - Press Enter to Close'
dmenu_tutorialsvid.sh v.1.0.0 - Help
====================================
Manage video tutorials

Actions on videos:
  Add        →Add new video.
  Copy       →Copy video to the clipboard.
  Delete     →Delete selected video.
  Edit       →Edit video for modifications.
  Help       →Show this help

Configuration: 
  TUTORIALS_PATH="${HOME}/bin/"
  VIDEOS_FILE="${HOME}/bin/tutorials_vid.txt"
  TERMINAL="${TERMINAL:-st}"
EOF
}

# --- Show the menu ---
menu() {
    local prompt="$1"
    dmenu -c -i -l 20 "${DMENU_APPEARANCE[@]:-}" -p "$prompt"
}

# --- Checks if the programs passed as strings are installed ---
chk_dependencies() {
    local -a dependencies_array=("$@")
    local -a missing=()

    for program in "${dependencies_array[@]}"; do
        if ! command -v "$program" >/dev/null; then
            missing+=("$program")
        fi
    done

    if [[ "${#missing[@]}" -gt 0 ]]; then
        local missing_programs="${missing[*]}"
        echo "Install the missing dependencies before continuing: $missing_programs"
        notify "[ERROR]" "Missing programs: $missing_programs" "critical"
        exit 1
    fi
}

# --- Extract URL from exact title match ---
get_url_from_title() {
    local title="$1"
    local line url_part

    while IFS= read -r line; do
        # Skip empty lines
        [ -z "$line" ] && continue

        # Check if line starts with "$title:" or "$title :" (allow one optional space)
        if [[ "$line" == "$title:"* ]] || [[ "$line" == "$title :"* ]]; then
            # Remove everything up to and including the first colon
            url_part="${line#*:}"

            # Remove leading spaces and tabs
            while [[ "${url_part:0:1}" == " " || "${url_part:0:1}" == $'\t' ]]; do
                url_part="${url_part#?}"
            done

            printf '%s\n' "$url_part"
            return 0
        fi
    done <"$VIDEOS_FILE"

    return 1
}

# --- Select a video title using ---
get_video() {
    local selected
    # Extract only titles (part before first colon)
    selected=$(cut -d: -f1 "$VIDEOS_FILE" | menu "Choose a video: ")
    if [[ -n "$selected" ]]; then
        echo "$selected"
    fi
}

# --- Make a backup of VIDEOS_FILE ---
make_backup() {
    cp -f "$VIDEOS_FILE" "$VIDEOS_FILE".bak
    notify "[BACKUP]" "Created backup file" "normal"
}

# --- Sort videos ---
sort_videos() {
    local temp
    temp=$(mktemp)
    grep -v '^[[:space:]]*$' "$VIDEOS_FILE" | sort >"$temp"
    cp -f "$temp" "$VIDEOS_FILE"
}

# --- Edit video ---
edit_video() {
    local video_to_edit
    video_to_edit=$(get_video) || return

    # Find line number using grep -n and cut
    local line_num
    line_num=$(grep -n "^${video_to_edit}:" "$VIDEOS_FILE" | head -n1 | cut -d: -f1)

    if [[ -z "$line_num" ]]; then
        # Try with one space after title (to match "title : url")
        line_num=$(grep -n "^${video_to_edit} :" "$VIDEOS_FILE" | head -n1 | cut -d: -f1)
    fi

    if [[ -n "$line_num" ]]; then
        setsid -fw "$TERMINAL" -e nvim "$VIDEOS_FILE" "+$line_num" &>/dev/null
        sort_videos
        make_backup
    else
        notify "[ERROR]" "Could not locate video in file" "critical"
    fi
}

# --- New video ---
new_video() {
    setsid -fw "$TERMINAL" -e nvim "$VIDEOS_FILE" &>/dev/null
    if [[ -s "$VIDEOS_FILE" ]]; then
        notify "[NEW VIDEO]" "Added new video" "normal"
    else
        notify "[ERROR]" "No video added!" "critical"
    fi
}
# --- Delete video ---
delete_video() {
    local selected_video="$1"
    if [[ -z "$selected_video" ]]; then
        return 1
    fi

    local tmpfile
    tmpfile="$(mktemp)" || {
        notify "[ERROR]" "Could not create temp file" "critical"
        exit 1
    }

    # Remove lines that start with "$selected_video:" or "$selected_video :"
    while IFS= read -r line; do
        case "$line" in
        "$selected_video:"* | "$selected_video :"*)
            continue # skip (delete)
            ;;
        *)
            printf '%s\n' "$line"
            ;;
        esac
    done <"$VIDEOS_FILE" >"$tmpfile"

    mv "$tmpfile" "$VIDEOS_FILE"
}
# --- Choose action---
select_action() {
    local -a actions=("Add" "Copy" "Delete" "Edit" "Help" "Play")
    local choice
    choice=$(printf "%s\n" "${actions[@]}" | menu "Videos menu:")

    case $choice in
    "Add")
        new_video
        ;;

    "Copy")
        local selected_video
        selected_video=$(get_video)
        if [[ -n "$selected_video" ]]; then
            local url
            url=$(get_url_from_title "$selected_video")
            if [[ -n "$url" ]]; then
                printf '%s' "$url" | xsel -ib
                notify "[CLIPBOARD]" "Video URL copied to clipboard" "normal"
            else
                notify "[ERROR]" "Could not extract URL" "critical"
            fi
        else
            notify "[CLIPBOARD]" "No video selected" "normal"
        fi
        ;;

    "Delete")
        local selected_video confirm_delete
        selected_video=$(get_video)
        if [[ -n "$selected_video" ]]; then
            confirm_delete=$(printf "Yes\nNo" | menu "Delete '$selected_video'? (Yes/No)")
            if [[ "$confirm_delete" == "Yes" ]]; then
                delete_video "$selected_video"
                notify "[VIDEO]" "Video deleted" "normal"
            else
                notify "[VIDEO]" "Video deletion cancelled" "normal"
            fi
        else
            notify "[VIDEO]" "No video selected for deletion" "normal"
        fi
        ;;

    "Edit")
        edit_video
        ;;

    "Help")
        show_help
        ;;

    "Play")
        local selected_video
        selected_video=$(get_video)
        if [[ -n "$selected_video" ]]; then
            local url
            url=$(get_url_from_title "$selected_video")
            if [[ -n "$url" ]]; then
                notify "Wait" "Loading video ..." "normal"
                mpv --ao=pulse --no-terminal "$url" &
            else
                notify "[ERROR]" "Could not extract URL to play" "critical"
            fi
        fi
        ;;
    esac
}
# --- Main function ---
main() {
    chk_dependencies "dmenu" "mpv" "notify-send" "xsel"
    check_videos
    select_action
}

main
