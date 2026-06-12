#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Spotify Launcher with Audio Service Management
#
# This script is designed to launch Spotify and ensure it runs with PulseAudio
# instead of PipeWire, which can be necessary on some Linux systems to resolve
# audio compatibility or performance issues with the Spotify client.
#
# Key features:
# - Checks for dependencies like `snap` and `spotify`.
# - Verifies it's running in a valid user session with D-Bus.
# - Launches Spotify in the background.
# - Intelligently stops active PipeWire-related services (`pipewire`,
#   `pipewire-pulse`, `wireplumber`).
# - Starts the `pulseaudio` service if it's not already running.
# - Sends desktop notifications to inform the user of its progress and status.
# - Provides robust logging and error handling.
#
# This is a workaround and might not be necessary on all systems.
# ==============================================================================

# --- Configuration ---
readonly SPOTIFY_CMD="spotify"
readonly ICON_SUCCESS="dialog-information"
readonly ICON_WARNING="dialog-warning"

# --- Helper Functions ---

# Log a message to standard error with a timestamp.
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

# Send a desktop notification. Falls back to logging if `notify-send` is not available.
send_notification() {
    local urgency="${1:-low}"
    local title="$2"
    local message="$3"
    local icon="${4:-}"

    if command -v notify-send >/dev/null 2>&1; then
        # The ${icon:+--icon="$icon"} syntax adds the --icon flag only if the 'icon' variable is set.
        notify-send -u "$urgency" "${title}" "${message}" ${icon:+--icon="$icon"}
    else
        log "Notification: [$urgency] $title — $message"
    fi
}

# Log an error, send a critical notification, and exit the script.
fatal() {
    local msg="$1"
    log "ERROR: $msg"
    send_notification "critical" "Spotify Launcher" "$msg" "$ICON_WARNING"
    exit 1
}

# --- Dependency & Environment Checks ---

# Check if snap is installed (a common installation method for Spotify).
if ! command -v snap >/dev/null 2>&1; then
    log "Warning: 'snap' command not found. Spotify might be installed via another method."
fi

# Check if the Spotify command itself is available.
if ! command -v "$SPOTIFY_CMD" >/dev/null 2>&1; then
    fatal "'$SPOTIFY_CMD' command not found. Please ensure Spotify is installed and in your PATH."
fi

# Ensure the script is run from a graphical user session by checking for the D-Bus socket.
# `systemctl --user` relies on D-Bus.
if [[ -z "${XDG_RUNTIME_DIR:-}" ]] || [[ ! -S "${XDG_RUNTIME_DIR}/bus" ]]; then
    fatal "User D-Bus session not detected. This script must be run from a graphical login."
fi

# --- Main Logic ---

log "Attempting to launch Spotify..."
# Launch Spotify in the background so the script can continue.
"$SPOTIFY_CMD" &
SPOTIFY_PID=$!

# Wait briefly for the process to initialize.
# Note: A more robust solution might involve polling for a window or process state.
sleep 2

# Verify that the Spotify process actually started.
if ! kill -0 "$SPOTIFY_PID" 2>/dev/null; then
    fatal "Spotify process failed to start or terminated unexpectedly."
fi

log "Spotify started (PID: $SPOTIFY_PID). Now managing audio services..."

# Define the services that conflict with PulseAudio for this use case.
readonly services_to_stop=("pipewire" "pipewire-pulse" "wireplumber")
for svc in "${services_to_stop[@]}"; do
    if systemctl --user is-active --quiet "$svc"; then
        log "Stopping active service: $svc..."
        if ! systemctl --user stop "$svc"; then
            # Not using fatal() here to allow the script to continue if one service fails to stop.
            log "Warning: Failed to stop '$svc'. Audio may not work as expected."
        fi
    else
        log "Service '$svc' is not active; skipping."
    fi
done

# Start the PulseAudio service if it's not already running.
if ! systemctl --user is-active --quiet pulseaudio; then
    log "Starting PulseAudio service..."
    if ! systemctl --user start pulseaudio; then
        fatal "Failed to start the PulseAudio service. Cannot continue."
    fi
else
    log "PulseAudio service is already active."
fi

send_notification "normal" "Spotify" "Spotify launched with PulseAudio." "$ICON_SUCCESS"
log "Script finished successfully. Spotify should be running with PulseAudio."

exit 0
