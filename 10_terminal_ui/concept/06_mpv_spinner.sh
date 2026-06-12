#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Smart Video Player with Loading Spinner
#
# This script launches a video URL with `mpv` and displays an elegant spinner
# animation while the player is buffering or connecting. The spinner stops
# once `mpv` reports that audio or video output has started.
#
# How it Works:
# 1. A temporary log file is created to capture `mpv`'s output.
# 2. A spinner animation is started as a background process.
# 3. `mpv` is launched in the background (with `setsid -f`) and all its output
#    is redirected to the temporary log file.
# 4. A `while` loop polls the log file, looking for "AO:" (Audio Output) or
#    "VO:" (Video Output), which indicates playback has begun.
# 5. A timeout is included to prevent the script from waiting indefinitely.
# 6. Once playback starts (or times out), the spinner process is killed and
#    the temporary log file is removed.
#
# Dependencies:
# - `mpv`: A command-line video player.
# ==============================================================================

# --- The Core Function ---
play_with_smart_spinner() {
    local url="$1"
    local pid_spinner
    local temp_log

    # 1. Create a temporary file to capture mpv's verbose output.
    temp_log=$(mktemp)

    # 2. Start the spinner animation in a background subshell.
    (
        local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏' # A nice spinner character set
        local i=0
        # Loop indefinitely, printing the next spinner frame.
        while true; do
            # `>&2` prints the spinner to stderr so it doesn't pollute stdout.
            printf "\r\033[1;32mLoading video... %s\033[0m" "${spin:i++%${#spin}:1}" >&2
            sleep 0.1
        done
    ) &
    pid_spinner=$! # Capture the Process ID of the spinner subshell.

    # 3. Launch mpv.
    # `setsid -f`: Runs mpv in a new session, fully detaching it from the terminal.
    # `>` and `2>&1`: Redirects both stdout and stderr to our temporary log file.
    # `&`: Runs the command in the background.
    setsid -f mpv --no-terminal --ao=pulse "$url" > "$temp_log" 2>&1 &

    # 4. The Smart Monitoring Loop.
    # This loop waits until "AO:" or "VO:" appears in the log, indicating successful start.
    local timeout=300 # Timeout counter (300 * 0.1s = 30 seconds).
    while true; do
        # `grep -q` quietly checks for the pattern. It returns 0 if found.
        if grep -q -E "AO:|VO:" "$temp_log"; then
            break # Exit the loop if playback has started.
        fi

        # Decrement the timeout counter.
        ((timeout--))
        if ((timeout <= 0)); then
            kill "$pid_spinner" 2> /dev/null # Clean up the spinner.
            # Print an error message, clearing the line first.
            printf "\r%-50s\n" "Error: Connection timed out after 30 seconds." >&2
            rm "$temp_log"
            return 1 # Return a failure code.
        fi

        sleep 0.1
    done

    # 5. Cleanup on Success.
    kill "$pid_spinner" 2> /dev/null # Stop the spinner.
    rm "$temp_log"                   # Remove the log file.
    # Clear the spinner line and print a success message.
    printf "\r%-50s\n" "✅ Video playback started!" >&2
}

# --- Main Entry Point ---
main() {
    # Check for dependencies first.
    if ! command -v mpv &> /dev/null; then
        echo "Error: 'mpv' is not installed. Please install it to play videos." >&2
        exit 1
    fi

    local url="$1"
    # Check if a URL was provided.
    if [[ -z "$url" ]]; then
        echo "Error: Missing video URL." >&2
        echo "Usage: ${0##*/} <url>" >&2
        exit 1
    fi

    play_with_smart_spinner "$url"
}

# --- Script Start ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
