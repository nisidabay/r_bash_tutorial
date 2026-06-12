#!/usr/bin/env bash
#
# Create an encrypted CD-ROM
# Author: nisidabay
# Date: 2023-02-08
# Version: 2.0
#
##############################################################################

# Strict mode
set -euo pipefail

# Constants
readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_VERSION="2.0"
readonly DEFAULT_CD_SIZE=700
readonly IMAGE_PATH="/tmp/encrypted.img"
readonly MOUNT_POINT="/mnt/cdrom"
readonly MAPPER_NAME="encrypted"

# Configuration (can be overridden by options)
CD_SIZE=${CD_SIZE:-$DEFAULT_CD_SIZE}
VERBOSE=${VERBOSE:-0}

# Colors
readonly RED='\033[1;31m'
readonly GREEN='\033[1;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[1;34m'
readonly NC='\033[0m' # No Color

##############################################################################
# Utility Functions
##############################################################################

log() {
    echo -e "${GREEN}::${NC} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}⚠️${NC} $*" >&2
}

log_error() {
    echo -e "${RED}⛔${NC} $*" >&2
}

log_verbose() {
    if [[ $VERBOSE -eq 1 ]]; then
        echo -e "${BLUE}[DEBUG]${NC} $*" >&2
    fi
}

die() {
    log_error "$*"
    exit 1
}

# Cleanup function
cleanup() {
    local exit_code=$?
    log_verbose "Cleanup triggered with exit code: $exit_code"

    # Attempt to unmount and close if they exist
    if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
        log_warn "Unmounting $MOUNT_POINT..."
        sudo umount "$MOUNT_POINT" 2>/dev/null || true
    fi

    if [[ -e "/dev/mapper/$MAPPER_NAME" ]]; then
        log_warn "Closing encrypted mapper..."
        sudo cryptsetup luksClose "$MAPPER_NAME" 2>/dev/null || true
    fi

    return "$exit_code"
}

# Set up trap for cleanup
trap cleanup EXIT INT TERM

# Check if running with sudo privileges when needed
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        log_warn "This script requires sudo privileges. You may be prompted for your password."
        sudo -v || die "Failed to obtain sudo privileges"
    fi
}

# Check for required dependencies
check_dependencies() {
    local deps=("cryptsetup" "dd" "mkfs.ext4" "wodim" "du" "mountpoint")
    local missing=()

    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing required dependencies: ${missing[*]}"
    fi

    log_verbose "All dependencies found"
}

# Notify user (optional, won't fail if notify-send is not available)
notify() {
    if command -v notify-send &>/dev/null; then
        notify-send "$@" 2>/dev/null || true
    fi
}

##############################################################################
# Confirmation Function
##############################################################################

confirm() {
    local prompt="$1"
    local default="${2:-}"
    local color="$YELLOW"
    local default_text="[y/n]"

    case "$default" in
    [Yy][Ee][Ss])
        default_text="[Y/n]"
        color="$GREEN"
        ;;
    [Nn][Oo])
        default_text="[y/N]"
        color="$RED"
        ;;
    esac

    echo -ne "${color}::${NC} ${prompt}? ${color}${default_text}:${NC} " >&2

    read -r response

    case "$response" in
    [Yy]*)
        return 0
        ;;
    [Nn]*)
        return 1
        ;;
    "")
        # Empty response - use default
        case "$default" in
        [Yy][Ee][Ss])
            return 0
            ;;
        [Nn][Oo])
            return 1
            ;;
        *)
            return 1
            ;;
        esac
        ;;
    *)
        echo -e "${RED}Invalid response. Please answer y or n.${NC}" >&2
        confirm "$prompt" "$default"
        ;;
    esac
}

##############################################################################
# Core Functions
##############################################################################

get_folder_size_mb() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        echo "0"
        return 1
    fi

    # Get size in MB
    local size_kb
    size_kb=$(du -sk "$dir" | awk '{print $1}')
    echo $((size_kb / 1024))
}

create_image() {
    log "Creating encrypted image (${CD_SIZE}MB)..."

    if [[ -e "$IMAGE_PATH" ]]; then
        if confirm "Image $IMAGE_PATH already exists. Overwrite it" "no"; then
            rm -f "$IMAGE_PATH"
        else
            die "Aborted by user"
        fi
    fi

    check_sudo

    log "Creating ${CD_SIZE}MB image file..."
    dd if=/dev/zero of="$IMAGE_PATH" bs=1M count="$CD_SIZE" status=progress || die "Failed to create image"

    log "Formatting with LUKS encryption..."
    sudo cryptsetup luksFormat "$IMAGE_PATH" || die "Failed to format with LUKS"

    log "Opening encrypted container..."
    sudo cryptsetup luksOpen "$IMAGE_PATH" "$MAPPER_NAME" || die "Failed to open LUKS container"

    log "Creating ext4 filesystem..."
    sudo mkfs.ext4 -L "EncryptedCD" "/dev/mapper/$MAPPER_NAME" || die "Failed to create filesystem"

    log "Closing encrypted container..."
    sudo cryptsetup luksClose "$MAPPER_NAME" || log_warn "Failed to close container (may already be closed)"

    log "✅ Encrypted image created successfully at $IMAGE_PATH"
}

copy_data() {
    check_sudo

    if [[ ! -e "$IMAGE_PATH" ]]; then
        die "Image $IMAGE_PATH does not exist. Run with -i first to create it."
    fi

    log "Opening encrypted container..."
    sudo cryptsetup luksOpen "$IMAGE_PATH" "$MAPPER_NAME" || die "Failed to open LUKS container"

    log "Creating mount point..."
    sudo mkdir -p "$MOUNT_POINT"

    log "Mounting encrypted filesystem..."
    sudo mount -o rw,nosuid,nodev,relatime "/dev/mapper/$MAPPER_NAME" "$MOUNT_POINT" || {
        sudo cryptsetup luksClose "$MAPPER_NAME"
        die "Failed to mount filesystem"
    }

    log "Adjusting permissions..."
    sudo chown -R "$USER:$USER" "$MOUNT_POINT" || log_warn "Could not change ownership"

    log "💿 Ready to copy data to $MOUNT_POINT"
    notify "💿 Image mounted" "Copy data to $MOUNT_POINT"

    # Show usage
    local available
    available=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $4}')
    log "Available space: $available"

    echo ""
    log "Copy your files to $MOUNT_POINT, then press Enter to continue..."
    read -r
}

burn_cd() {
    check_sudo

    if [[ ! -e "$IMAGE_PATH" ]]; then
        die "Image $IMAGE_PATH does not exist."
    fi

    # Check if data was copied
    local data_size
    data_size=$(get_folder_size_mb "$MOUNT_POINT")

    log "Current data size: ${data_size}MB / ${CD_SIZE}MB"

    if [[ $data_size -gt $CD_SIZE ]]; then
        die "Data size (${data_size}MB) exceeds CD capacity (${CD_SIZE}MB)"
    fi

    if [[ $data_size -eq 0 ]]; then
        log_warn "No data found in $MOUNT_POINT"
        if ! confirm "Continue burning empty image" "no"; then
            die "Aborted by user"
        fi
    fi

    # Unmount before burning
    if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
        log "Unmounting $MOUNT_POINT..."
        sudo umount "$MOUNT_POINT" || die "Failed to unmount"
    fi

    if [[ -e "/dev/mapper/$MAPPER_NAME" ]]; then
        log "Closing encrypted container..."
        sudo cryptsetup luksClose "$MAPPER_NAME" || die "Failed to close container"
    fi

    log "🔥 Ready to burn CD-ROM"
    notify "🔥 Data ready" "Preparing to burn CD-ROM"

    if ! confirm "Burn CD-ROM now" "yes"; then
        die "Aborted by user"
    fi

    log "Burning image to CD-ROM..."
    if sudo wodim -v dev=/dev/sr0 -data -eject "$IMAGE_PATH"; then
        log "✅ Image successfully burnt to CD-ROM!"
        notify "✅ Success" "CD-ROM burned successfully"
    else
        die "Failed to burn CD-ROM"
    fi
}

see_content() {
    check_sudo

    log "💿 Insert the encrypted CD-ROM and press Enter..."
    read -r

    # Wait a moment for the drive to recognize the disc
    sleep 2

    if [[ ! -e /dev/sr0 ]]; then
        die "CD-ROM drive /dev/sr0 not found"
    fi

    log "Opening encrypted CD-ROM..."
    if ! sudo cryptsetup luksOpen /dev/sr0 "$MAPPER_NAME"; then
        log_error "Failed to open CD-ROM directly. Attempting to copy to image first..."

        log "Copying CD-ROM to image file..."
        dd if=/dev/sr0 of="$IMAGE_PATH" bs=1M status=progress || die "Failed to copy CD-ROM"

        log "Opening copied image..."
        sudo cryptsetup luksOpen "$IMAGE_PATH" "$MAPPER_NAME" || die "Failed to open copied image"
    fi

    log "Creating mount point..."
    sudo mkdir -p "$MOUNT_POINT"

    log "Mounting encrypted filesystem..."
    sudo mount -o ro,nosuid,nodev,relatime "/dev/mapper/$MAPPER_NAME" "$MOUNT_POINT" || die "Failed to mount"

    # Check content
    local data_size
    data_size=$(get_folder_size_mb "$MOUNT_POINT")

    log "Content size: ${data_size}MB"

    if [[ $data_size -gt 0 ]]; then
        log "👌 Data found on CD-ROM"

        # Use file manager if available
        if command -v vifm &>/dev/null; then
            vifm "$MOUNT_POINT"
        elif command -v ranger &>/dev/null; then
            ranger "$MOUNT_POINT"
        elif command -v mc &>/dev/null; then
            mc "$MOUNT_POINT"
        else
            log "File manager not found. Listing contents:"
            ls -lah "$MOUNT_POINT"
            log "Mount point: $MOUNT_POINT"
            read -rp "Press Enter to continue..."
        fi
    else
        log_warn "No data found or CD-ROM may be damaged"
    fi
}

umount_image() {
    check_sudo

    log "Cleaning up..."

    if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
        log "Unmounting $MOUNT_POINT..."
        sudo umount "$MOUNT_POINT" || log_warn "Failed to unmount"
    fi

    if [[ -e "/dev/mapper/$MAPPER_NAME" ]]; then
        log "Closing encrypted container..."
        sudo cryptsetup luksClose "$MAPPER_NAME" || log_warn "Failed to close container"
    fi

    if [[ -e "$IMAGE_PATH" ]]; then
        if confirm "Delete image file $IMAGE_PATH" "yes"; then
            sudo rm -f "$IMAGE_PATH"
            log "Deleted $IMAGE_PATH"
        fi
    fi

    log "✨ Cleanup complete"

    # Eject CD if present
    if [[ -e /dev/sr0 ]]; then
        eject 2>/dev/null || true
    fi
}

##############################################################################
# Help Function
##############################################################################

show_help() {
    cat <<EOF
🔐 💿 🔐  Encrypted CD-ROM Utility

Usage: $SCRIPT_NAME [OPTIONS]

Options:
    -i              Create encrypted image
    -c              Copy data to image (mounts the image)
    -b              Burn image to CD-ROM
    -s              See CD-ROM content (read encrypted disc)
    -u              Unmount and cleanup
    -S <size>       Set CD size in MB (default: $DEFAULT_CD_SIZE)
    -v              Verbose output
    -h              Show this help message

Environment Variables:
    CD_SIZE         Override default CD size (default: $DEFAULT_CD_SIZE MB)
    VERBOSE         Enable verbose output (set to 1)

Examples:
    # Create a 700MB encrypted image
    $SCRIPT_NAME -i

    # Create a custom-sized image
    $SCRIPT_NAME -S 4700 -i

    # Mount image for copying data
    $SCRIPT_NAME -c

    # Burn to CD-ROM
    $SCRIPT_NAME -b

    # Read encrypted CD-ROM
    $SCRIPT_NAME -s

    # Cleanup and unmount
    $SCRIPT_NAME -u

Workflow:
    1. Create image:    $SCRIPT_NAME -i
    2. Copy data:       $SCRIPT_NAME -c
    3. Burn CD:         $SCRIPT_NAME -b
    4. Read CD:         $SCRIPT_NAME -s
    5. Cleanup:         $SCRIPT_NAME -u

Version: $SCRIPT_VERSION
Author: nisidabay

Dependencies: cryptsetup, dd, mkfs.ext4, wodim, du
Optional: notify-send, vifm/ranger/mc
EOF
}

##############################################################################
# Main
##############################################################################

main() {
    local opt_counter=0

    # Parse options
    while getopts "hicbsuS:v" option; do
        case $option in
        i)
            check_dependencies
            create_image
            ((opt_counter++))
            ;;
        c)
            check_dependencies
            copy_data
            ((opt_counter++))
            ;;
        b)
            check_dependencies
            burn_cd
            ((opt_counter++))
            ;;
        s)
            check_dependencies
            see_content
            ((opt_counter++))
            ;;
        u)
            umount_image
            ((opt_counter++))
            ;;
        S)
            CD_SIZE="$OPTARG"
            if ! [[ "$CD_SIZE" =~ ^[0-9]+$ ]]; then
                die "CD size must be a number"
            fi
            log_verbose "CD size set to ${CD_SIZE}MB"
            ;;
        v)
            VERBOSE=1
            log_verbose "Verbose mode enabled"
            ;;
        h)
            show_help
            exit 0
            ;;
        \?)
            log_error "Invalid option: -$OPTARG"
            show_help
            exit 1
            ;;
        esac
    done

    shift $((OPTIND - 1))

    # Ensure exactly one action was specified
    if [[ $opt_counter -eq 0 ]]; then
        show_help
        exit 0
    elif [[ $opt_counter -gt 1 ]]; then
        die "Please specify only one action at a time"
    fi
}

# Run main function
main "$@"
