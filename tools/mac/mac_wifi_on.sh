#!/usr/bin/env bash
#
# Enable wifi on a MacBook Pro

# Checks if the programs passed as strings are installed
chk_dependencies() {
    local -a dependencies_array=($@)
    local -a missing=()
    for program in "${dependencies_array[@]}"; do
        if ! command -v "$program" >/dev/null; then
            missing+=("$program")
        fi
d    done
    if [[ "${#missing[@]}" -gt 0 ]]; then
        local missing_programs="${missing[*]}"
        echo "Install the missing dependencies before continuing: $missing_programs"
        osascript -e "display notification \"Install the following programs before continuing: $missing_programs\" with title \"Missing Dependencies\""
        exit 1
    fi
}

# Execution starts HERE
chk_dependencies "networksetup" "osascript"

if networksetup -setnetworkserviceenabled "Wi-Fi" on; then
    echo "Wi-Fi has been turned ON."
    osascript -e 'display notification "Wi-Fi has been turned ON." with title "Wi-Fi Control"'
else
    echo "Failed to turn ON Wi-Fi."
    osascript -e 'display notification "Failed to turn ON Wi-Fi." with title "Wi-Fi Control"'
fi
