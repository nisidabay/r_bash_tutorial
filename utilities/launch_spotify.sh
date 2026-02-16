#!/usr/bin/env BASH

set -euo pipefail # Exit on error, undefined vars, or pipe failures

# --- Configuration ---
SPOTIFY_CMD="spotify"
ICON_SUCCESS="dialog-information"
ICON_WARNING="dialog-warning"

# --- Helper Functions ---

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

send_notification() {
    local urgency="${1:-low}"
    local title="$2"
    local message="$3"
    local icon="${4:-}"

    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u "$urgency" "${title}" "${message}" ${icon:+--icon="$icon"}
    else
        log "Notification: [$urgency] $title — $message"
    fi
}

fatal() {
    local msg="$1"
    send_notification "critical" "Spotify Launcher" "$msg" "$ICON_WARNING"
    log "ERROR: $msg"
    exit 1
}

# --- Dependency Checks ---

# Check if snap is installed (common for Spotify)
if ! command -v snap >/dev/null 2>&1; then
    log "Warning: 'snap' is not installed. Spotify may not be available."
fi

# Check if Spotify is installed
if ! command -v "$SPOTIFY_CMD" >/dev/null 2>&1; then
    fatal "Spotify is not installed. Please install it via Snap or another method."
fi

# Ensure we're in a user session with D-Bus (required for systemctl --user)
if [ -z "${XDG_RUNTIME_DIR:-}" ] || [ ! -S "${XDG_RUNTIME_DIR}/bus" ]; then
    fatal "User session not detected. This script must be run from a graphical login session."
fi

# --- Main Logic ---

log "Launching Spotify..."
"$SPOTIFY_CMD" &
SPOTIFY_PID=$!

# Give Spotify a moment to start
sleep 2

# Verify Spotify is actually running
if ! kill -0 "$SPOTIFY_PID" 2>/dev/null; then
    fatal "Spotify failed to start."
fi

log "Spotify started (PID: $SPOTIFY_PID). Now managing audio services..."

# Stop PipeWire services only if they are active
services_to_stop=("pipewire" "pipewire-pulse" "wireplumber")
for svc in "${services_to_stop[@]}"; do
    if systemctl --user is-active --quiet "$svc"; then
        log "Stopping $svc..."
        if ! systemctl --user stop "$svc"; then
            fatal "Failed to stop $svc."
        fi
    else
        log "$svc is not active; skipping."
    fi
done

# Start PulseAudio only if not already running
if ! systemctl --user is-active --quiet pulseaudio; then
    log "Starting PulseAudio..."
    if ! systemctl --user start pulseaudio; then
        fatal "Failed to start PulseAudio."
    fi
else
    log "PulseAudio is already running."
fi

send_notification "normal" "Spotify" "Spotify launched successfully with PulseAudio." "$ICON_SUCCESS"
log "Spotify launched successfully with PulseAudio."
