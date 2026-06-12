#!/usr/bin/bash
#
# Run preferred applications using wofi
# Define your shortcuts and commands here

# Define an array of shortcuts and corresponding commands
shortcuts=(
    "Calcurse:calcurse"
    "Calibre:calibre"
    "Firefox:firefox"
    "Galculator:galculator"
    "Geany:geany"
    "Neomutt"
    "Pavucontrol:pavucontrol"
    "Terminal:$TERMINAL"
    "Transmission:transmission"
    "USB Encrypt (Mount):usb_encrypt.sh -m"
    "USB Encrypt (Unmount):usb_encrypt.sh -u"
    "Vifm"
    "Xpad:xpad"
    "Zeal:zeal"
    "Zettlr:zettlr"
)

# Use wofi --dmenu to display the list of shortcuts and get user input
choice=$(printf '%s\n' "${shortcuts[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "Select an application to launch")

# Launch the chosen application or command
case "$choice" in

    *"USB Encrypt"*)
        command=$(echo "$choice" | cut -d':' -f2-)
        "$ALTERNATE_TERMINAL" -e sh -c "$command"
        ;;
    "Neomutt")
        "$ALTERNATE_TERMINAL" -e neomutt
        ;;
    "Vifm")
        "$ALTERNATE_TERMINAL" -e vifm
        ;;
    *)
        command=$(echo "$choice" | cut -d':' -f2-)
        eval "$command"
        ;;
esac

