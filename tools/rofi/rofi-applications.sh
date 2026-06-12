#!/usr/bin/env bash
#
# Run preferred applications using rofi menu

# Terminal emulator to use
TERMINAL="st"

# Define applications to check for dependencies
applications=(
    "audacity"
    "calcurse"
    "calibre"
    "firefox"
    "galculator"
    "neomutt"
    "transmission-gtk"
    "vifm"
    "xpad"
    "zeal"
)

# Define menu options
options=(
    "$TERMINAL"
    "audacity"
    "calcurse"
    "calibre"
    "firefox"
    "galculator"
    "neomutt"
    "transmission-gtk"
    "tor"
    "vifm"
    "xpad"
    "zeal"
)

# Check for the existence of required dependencies
check_deps() {
    missing_deps=0
    for dep in "${applications[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Error: $dep is required but not installed." >&2
            missing_deps=$((missing_deps + 1))
        fi
    done
    # If there are missing dependencies, exit with an error
    [ "$missing_deps" -ne 0 ] && exit 1
}

# Run dependency check
check_deps

# Display menu and get user choice
choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Select an application to launch")

# Exit if no choice was made
[ -z "$choice" ] && exit 0

# Launch the selected application
case "$choice" in
"USB Encrypt (Mount)")
    $TERMINAL -e bash -c "xdotool key n Return && xdotool type 'usb_encrypt.sh -m' && xdotool key Return" &
    ;;
"USB Encrypt (Unmount)")
    $TERMINAL -e bash -c "xdotool key n Return && xdotool type 'usb_encrypt.sh -u' && xdotool key Return" &
    ;;
"vifm")
    $TERMINAL -e vifm &
    ;;
"calcurse")
    $TERMINAL -e calcurse &
    ;;
"neomutt")
    $TERMINAL -e neomutt &
    ;;
"transmission-gtk")
    transmission-gtk &
    ;;
"tor")
    tor-browser-en &
    ;;
*)
    # Launch the application directly
    $choice &
    ;;
esac
