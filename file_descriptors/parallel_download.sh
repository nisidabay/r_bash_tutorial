#!/usr/bin/env BASH

# ===========================================================
# PARALLEL DOWNLOAD WITH MKFIFO — FINAL EDUCATIONAL VERSION
# Uses official Ubuntu mirror + correct checksum verification
# ===========================================================

# ----------------------------
# CONFIGURATION
# ----------------------------
readonly URL="https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-desktop-amd64.iso"
readonly OUTPUT_FILE="ubuntu.iso"
readonly EXPECTED_SHA256="faabcf33ae53976d2b8207a001ff32f4e5daae013505ac7188c9ea63988f8328"
readonly NUM_CHUNKS=2

# ----------------------------
# HELPER: Log with timestamp to stderr
# ----------------------------
log() {
    echo "[$(date -u +%T)] $*" >&2
}

# ----------------------------
# Get file size via HEAD request
# ----------------------------
get_file_size() {
    local size
    size=$(curl -sI "$URL" | grep -i '^content-length:' | awk '{print $2}' | tr -d '\r')

    if [[ -z "$size" ]] || ! [[ "$size" =~ ^[0-9]+$ ]]; then
        log "ERROR: Server does not support range requests or file not found."
        exit 1
    fi

    echo "$size"
}

# ----------------------------
# Download one chunk into FIFO
# ----------------------------
download_chunk() {
    local start="$1"
    local end="$2"
    local fifo="$3"

    if [[ -z "$end" ]]; then
        curl -s -L --range "$start-" "$URL" >"$fifo"
    else
        curl -s -L --range "$start-$end" "$URL" >"$fifo"
    fi
}

# ----------------------------
# Write chunk from FIFO to output file at offset
# ----------------------------
write_chunk() {
    local fifo="$1"
    local offset="$2"
    cat "$fifo" | dd of="$OUTPUT_FILE" bs=1 seek="$offset" conv=notrunc 2>/dev/null
}

# ----------------------------
# Start all parallel downloads
# ----------------------------
start_parallel_downloads() {
    local file_size="$1"
    local chunk_size=$((file_size / NUM_CHUNKS))
    local pids=()

    # Pre-allocate file to full size
    dd if=/dev/zero of="$OUTPUT_FILE" bs=1 count=0 seek="$file_size" 2>/dev/null

    for ((i = 0; i < NUM_CHUNKS; i++)); do
        local start=$((i * chunk_size))
        local end=""
        local fifo="pipe_$i"

        if ((i < NUM_CHUNKS - 1)); then
            end=$((start + chunk_size - 1))
        fi

        mkfifo "$fifo"

        download_chunk "$start" "$end" "$fifo" &
        pids+=($!)

        write_chunk "$fifo" "$start" &
        pids+=($!)

        log "Started chunk $((i + 1))/$NUM_CHUNKS (bytes $start-${end:-EOF})"
    done

    for pid in "${pids[@]}"; do
        wait "$pid"
    done

    rm -f pipe_*
}

# ----------------------------
# Verify checksum and clean up on failure
# ----------------------------
verify_checksum() {
    log "🔍 Verifying SHA256 checksum..."

    # Compute actual hash
    local actual_hash
    actual_hash=$(sha256sum "$OUTPUT_FILE" | cut -d' ' -f1)

    if [[ "$actual_hash" == "$EXPECTED_SHA256" ]]; then
        log "✅ Checksum MATCHES! File is valid."
        return 0
    else
        log "❌ Checksum MISMATCH!"
        log "Expected: $EXPECTED_SHA256"
        log "Got     : $actual_hash"
        log "⚠️  Deleting corrupted file..."
        rm -f "$OUTPUT_FILE"
        return 1
    fi
}

# ----------------------------
# MAIN FUNCTION
# ----------------------------
script_log() {
    log "🚀 Starting parallel download from official Ubuntu mirror..."

    local file_size
    file_size=$(get_file_size)
    log "📏 File size: $(printf "%'d" "$file_size") bytes"

    start_parallel_downloads "$file_size"

    if verify_checksum; then
        log "🎉 Success! Your file is ready: $OUTPUT_FILE"
    else
        log "💥 Failed. Please try again or use direct download."
        exit 1
    fi
}

# ----------------------------
# Run main if executed directly
# ----------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    script_log "$@"
fi
