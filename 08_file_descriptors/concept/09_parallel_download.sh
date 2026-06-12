#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Parallel Downloader using FIFOs
#
# This script demonstrates an advanced technique for downloading a single large
# file in multiple parallel chunks to potentially increase download speed. It
# uses named pipes (FIFOs) to stream data from `curl` processes directly to
# `dd` processes, which write the data to the correct offset in the final file.
#
# How it Works:
# 1.  **Get File Size**: It first sends a HEAD request with `curl -I` to get the
#     total size of the file. This is necessary to calculate the byte ranges
#     for each chunk.
# 2.  **Pre-allocate File**: It creates an empty file of the exact final size
#     using `dd seek=...`. This is crucial because the chunks will be written
#     out of order.
# 3.  **Create FIFOs**: For each chunk, it creates a named pipe (FIFO) using `mkfifo`.
#     A FIFO is a special file that acts as a buffer; data written to it can be
#     read by another process.
# 4.  **Start Downloads**: For each chunk, it starts a `curl` process that downloads
#     a specific byte range (`--range`) and writes its output to the corresponding FIFO.
# 5.  **Start Writers**: Simultaneously, it starts a `dd` process for each chunk
#     that reads from the FIFO and writes the data to the pre-allocated output
#     file at the correct `seek` offset.
# 6.  **Wait and Cleanup**: The main script waits for all background `curl` and `dd`
#     processes to complete, then removes the temporary FIFOs.
# 7.  **Verify**: Finally, it computes the SHA256 checksum of the assembled file
#     and compares it against a known value to ensure the download was not corrupted.
#
# Dependencies:
# - `curl`, `dd`, `sha256sum`, `mkfifo`
# ==============================================================================

# --- Configuration ---
readonly URL="https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-desktop-amd64.iso"
readonly OUTPUT_FILE="ubuntu.iso"
readonly EXPECTED_SHA256="faabcf33ae53976d2b8207a001ff32f4e5daae013505ac7188c9ea63988f8328"
# The number of parallel download chunks.
readonly NUM_CHUNKS=4

# --- Helper Functions ---

# Log a message to stderr with a UTC timestamp.
log() {
    echo "[$(date -u +%T)] $*" >&2
}

# Get the remote file size in bytes using a HEAD request.
get_file_size() {
    local size
    # `curl -sI` fetches headers only. `grep -i` finds the content-length line.
    size=$(curl -sI "$URL" | grep -i '^content-length:' | awk '{print $2}' | tr -d '\r')

    if [[ -z "$size" ]] || ! [[ "$size" =~ ^[0-9]+$ ]]; then
        log "ERROR: Could not determine file size. Server may not support range requests."
        exit 1
    fi
    echo "$size"
}

# Download a single chunk and stream it to a FIFO.
download_chunk() {
    local start="$1"
    local end="$2"
    local fifo_path="$3"
    # `curl -L` follows redirects. `--range` specifies the byte range.
    # The output is redirected to the named pipe.
    curl -s -L --range "$start-$end" "$URL" >"$fifo_path"
}

# Read a chunk from a FIFO and write it to the output file at a specific offset.
write_chunk() {
    local fifo_path="$1"
    local write_offset="$2"
    # `dd` reads from stdin (piped from `cat`) and writes to the output file.
    # `bs=1`: block size of 1 byte for precise writing.
    # `seek=...`: specifies the offset in blocks to start writing at.
    # `conv=notrunc`: ensures `dd` does not truncate the output file.
    cat "$fifo_path" | dd of="$OUTPUT_FILE" bs=1 seek="$write_offset" conv=notrunc status=none
}

# Orchestrates the creation of FIFOs and the start of all download/write processes.
start_parallel_downloads() {
    local file_size="$1"
    local chunk_size=$((file_size / NUM_CHUNKS))
    local -a pids=() # Array to store the PIDs of background processes.

    # Pre-allocate the output file to its full size. This is critical.
    log "Pre-allocating '$OUTPUT_FILE' ($((file_size / 1024 / 1024)) MiB)..."
    dd if=/dev/zero of="$OUTPUT_FILE" bs=1 count=0 seek="$file_size" status=none

    for ((i = 0; i < NUM_CHUNKS; i++)); do
        local start=$((i * chunk_size))
        local end=""
        local fifo="pipe_$i"

        # The last chunk downloads to the end of the file.
        if ((i < NUM_CHUNKS - 1)); then
            end=$((start + chunk_size - 1))
        fi

        # Create the named pipe.
        mkfifo "$fifo"

        # Start the download and write processes in the background.
        download_chunk "$start" "$end" "$fifo" &
        pids+=($!)
        write_chunk "$fifo" "$start" &
        pids+=($!)

        log "  [Chunk $((i + 1))/$NUM_CHUNKS] Started download for bytes $start-${end:-EOF}"
    done

    # Wait for all background processes to finish.
    log "Waiting for all chunks to complete..."
    for pid in "${pids[@]}"; do
        wait "$pid"
    done
    log "All chunks finished."

    # Clean up the named pipes.
    rm -f pipe_*
}

# Verify the SHA256 checksum of the downloaded file.
verify_checksum() {
    log "🔍 Verifying SHA256 checksum..."
    local actual_hash
    actual_hash=$(sha256sum "$OUTPUT_FILE" | cut -d' ' -f1)

    if [[ "$actual_hash" == "$EXPECTED_SHA256" ]]; then
        log "✅ Checksum MATCHES! File is valid."
        return 0
    else
        log "❌ Checksum MISMATCH!"
        log "   Expected: $EXPECTED_SHA256"
        log "   Got     : $actual_hash"
        log "⚠️ Deleting corrupted file..."
        rm -f "$OUTPUT_FILE"
        return 1
    fi
}

# --- Main Function ---
main() {
    # It would be good to add a dependency check here for curl, dd, etc.
    log "🚀 Starting parallel download..."

    local file_size
    file_size=$(get_file_size)
    log "📏 Remote file size: $(printf "%'d" "$file_size") bytes"

    start_parallel_downloads "$file_size"

    if verify_checksum; then
        log "🎉 Success! Download complete: $OUTPUT_FILE"
    else
        log "💥 Download failed due to checksum mismatch."
        exit 1
    fi
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
