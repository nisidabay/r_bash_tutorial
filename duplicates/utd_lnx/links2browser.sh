#!/usr/bin/env bash
#
# links2browser.sh: Display and open YouTube links using rofi and browser
# Author: clacmoy
# Date: Mon Dec 23 05:35:14 AM CET 2024
#
# Dependencies: rofi, firefox

readonly MEDIA_FILES="$HOME/Downloads/youtube-dl/youtube_links.txt"
readonly ROFI="$(which rofi)"
readonly BROWSER="$(which firefox)"

# Error messages
readonly ERR_ROFI="[!] rofi not installed"
readonly ERR_BROWSER="[!] $BROWSER not installed"
readonly ERR_MEDIA="[!] File not found: $MEDIA_FILES"

check_dependencies() {
    [[ ! -f "$ROFI" ]] && {
        echo "$ERR_ROFI"
        exit 1
    }
    [[ ! -f "$BROWSER" ]] && {
        echo "$ERR_BROWSER"
        exit 1
    }
    [[ ! -f "$MEDIA_FILES" ]] && {
        echo "$ERR_MEDIA"
        exit 1
    }
}

load_media_links() {
    declare -A media

    # Load title=url pairs from youtube_links.txt into associative array
    while IFS='=' read -r title url; do
        [[ -n "$title" && -n "$url" ]] && media["$title"]="$url"
    done <"$MEDIA_FILES"

    # Get selection from rofi
    selection=$(printf '%s\n' "${!media[@]}" | sort | "$ROFI" -dmenu)

    # If selection was made, open URL in browser
    [[ -n "$selection" ]] && "$BROWSER" "${media[$selection]}" >/dev/null 2>&1 &
}

main() {
    check_dependencies
    load_media_links
}

main
