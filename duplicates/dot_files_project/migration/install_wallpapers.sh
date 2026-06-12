#!/usr/bin/env bash
#
# wallpaper_installer.sh - Install wallpapers from a git repository
#
# Description:
#     Installs wallpapers from a git repository to a local directory.
#     Creates the target directory if it doesn't exist.

set -euo pipefail

# Define paths
readonly WALLPAPERS_REPO="${HOME}/git_projects/wallpapers"
readonly WALLPAPERS_DIR="${HOME}/Pictures/wallpaper"

# Logging functions
log_info() { echo "[INFO] $1"; }
log_error() { echo "[ERROR] $1" >&2; }

# Create wallpapers directory if it doesn't exist
setup_directory() {
    if [[ ! -d "${WALLPAPERS_DIR}" ]]; then
        mkdir -p "${WALLPAPERS_DIR}" || {
            log_error "Failed to create ${WALLPAPERS_DIR}"
            exit 1
        }
    fi
}

# Install wallpapers from repository
install_wallpapers() {
    # Clone repository if it doesn't exist
    if [[ ! -d "${WALLPAPERS_REPO}" ]]; then
        git clone git@gitlab.com:nisidabay/wallpapers.git "${WALLPAPERS_DIR}" || {
            log_error "Failed to clone repository"
            exit 1
        }
        return
    fi

    # Copy image files from existing repository
    find "${WALLPAPERS_REPO}" -type f \( -name "*.jpg" -o -name "*.png" \) -print0 |
        while IFS= read -r -d '' file; do
            cp "$file" "${WALLPAPERS_DIR}/" && log_info "Copied: $(basename "$file")"
        done
}

main() {
    log_info "Starting wallpaper installation..."
    setup_directory
    install_wallpapers
    log_info "Installation completed"
}

main
