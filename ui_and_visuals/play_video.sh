#!/usr/bin/env BASH
#
# Play videos using mpv

play_smart_spinner() {
    local url="$1"
    local pid_spinner
    local temp_log

    # 1. Create a temporary file to capture mpv output
    temp_log=$(mktemp)

    # 2. Start Spinner
    (
        local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        local i=0
        while true; do
            printf "\rLoading video... %s" "${spin:i++%${#spin}:1}" >&2
            sleep 0.1
        done
    ) &
    pid_spinner=$!

    # 3. Launch mpv
    # Redirect (> ) all output to our temp_log file.
    setsid -f mpv --ao=pulse "$url" >"$temp_log" 2>&1 &

    # 4. The Smart Loop
    # Wait until "AO:" (Audio Output) or "VO:" (Video Output) appears in the log.
    # Includes a 30-second timeout.
    local timeout=300 # 300 * 0.1s = 30 seconds
    while true; do
        # Check if playback started (grep returns 0 if found)
        if grep -q -E "AO:|V:" "$temp_log"; then
            break
        fi

        # Decrement timeout
        ((timeout--))
        if [ "$timeout" -le 0 ]; then
            kill "$pid_spinner" 2>/dev/null
            printf "\r%-50s\n" "Error: Connection timed out." >&2
            rm "$temp_log"
            return 1
        fi

        sleep 0.1
    done

    # 5. Cleanup
    kill "$pid_spinner" 2>/dev/null
    rm "$temp_log"
    printf "\r%-50s\n" "Video playback started!" >&2
}
main() {
    local url
    url=${1:-} && [[ -z "$url" ]] && {
        echo "Missing video url"
        echo "Usage ${0##/} <url>"
        exit
    }
    play_smart_spinner "$url"

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$1"
fi
