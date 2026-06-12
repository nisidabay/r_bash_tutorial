#!/usr/bin/env bash
#
# Run preferred applications using wofi
# Define your shortcuts and commands here

# Define an array of shortcuts and corresponding commands
TERMINAL="${TERMINAL:-st}"
shortcuts=(
    "Calcurse:calcurse"
    "Calibre:calibre"
    "Firefox:firefox"
    "Galculator:galculator"
    "Neomutt"
    "Pavucontrol:pavucontrol"
    "Terminal:$TERMINAL"
    "USB Encrypt (Mount):usb_encrypt.sh -m"
    "USB Encrypt (Unmount):usb_encrypt.sh -u"
    "Vifm"
)

# Use rofi --dmenu to display the list of shortcuts and get user input
choice=$(printf '%s\n' "${shortcuts[@]}" | rofi -dmenu -p "Select an application to launch")

# Launch the chosen application or command
case "$choice" in

*"USB Encrypt"*)
    command=$(echo "$choice" | cut -d':' -f2-)
    "$TERMINAL" -e sh -c "$command"
    ;;
"Neomutt")
    "$TERMINAL" -e neomutt
    ;;
"Vifm")
    "$TERMINAL" -e vifm
    ;;
*)
    command=$(echo "$choice" | cut -d':' -f2-)
    eval "$command"
    ;;
esac
