#!/usr/bin/env BASH
#
# Matrix like in BASH
# 1. The 'trap' command: This catches Ctrl+C.
# When you quit, it runs 'tput rmcup' to go back to your normal screen
# and 'tput cnorm' to bring your cursor back.
trap 'tput rmcup; tput cnorm; exit 0' SIGINT

# 2. Enter the "Sandbox" (Alternate Screen)
# 'smcup' switches to the alternate buffer (no history saved)
# 'civis' hides the blinking cursor so it doesn't distract from the rain
tput smcup
tput civis
tput clear

# Set text to bright green
echo -e "\033[1;32m"

width=$(tput cols)

while true; do
    line=""
    for ((i = 0; i < width; i++)); do
        rand=$((RANDOM % 10))
        if [ $rand -gt 7 ]; then
            line="$line$((RANDOM % 2))"
        else
            line="$line "
        fi
    done

    echo "$line"
    sleep 0.10
done
