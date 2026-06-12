#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Stow Migration Script
# This script migrates a "Frankenstein" dotfiles structure to a clean,
# stow-compatible structure.
#
# It assumes the following old structure:
# - folders_to_config_dir/
# - dotfiles_to_home/
# - folders_to_cache_dir/
# - folders_to_home_dir/
#
# And converts it to:
# - package_name/.config/
# - package_name/
# - package_name/.cache/
# - package_name/
# ==============================================================================

# --- Configuration ---

# Define your old "Frankenstein" folders
readonly CONFIG_SRC="folders_to_config_dir"
readonly HOME_SRC="dotfiles_to_home"
readonly CACHE_SRC="folders_to_cache_dir"
readonly HOME_FOLDERS_SRC="folders_to_home_dir"

# --- Main Logic ---

echo "-------------------------------------------------"
echo "Starting Migration to Pure Stow Structure..."
echo "-------------------------------------------------"

# 1. Migrate .config folders
# FROM: folders_to_config_dir/alacritty
# TO:   alacritty/.config/alacritty
if [[ -d "$CONFIG_SRC" ]]; then
    echo "📦 Migrating Config folders..."
    for folder in "$CONFIG_SRC"/*; do
        [ -d "$folder" ] || continue
        package_name=$(basename "$folder")

        echo "   -> Processing $package_name"
        mkdir -p "$package_name/.config"
        mv "$folder" "$package_name/.config/"
    done
    # Remove the empty source directory
    rmdir "$CONFIG_SRC" 2>/dev/null || echo "   (Note: $CONFIG_SRC not empty, kept)"
else
    echo "👍 No '$CONFIG_SRC' directory found, skipping."
fi

# 2. Migrate Home Dotfiles (e.g. git, shell)
# FROM: dotfiles_to_home/git/.gitconfig
# TO:   git/.gitconfig
if [[ -d "$HOME_SRC" ]]; then
    echo "🏠 Migrating Home dotfiles..."
    for folder in "$HOME_SRC"/*; do
        [ -d "$folder" ] || continue
        package_name=$(basename "$folder")

        echo "   -> Processing $package_name"
        # Since these are already individual files inside a folder
        # we just move the folder to the root.
        mv "$folder" .
    done
    rmdir "$HOME_SRC" 2>/dev/null || echo "   (Note: $HOME_SRC not empty, kept)"
else
    echo "👍 No '$HOME_SRC' directory found, skipping."
fi

# 3. Migrate Home Folders (e.g. .ssh)
# FROM: folders_to_home_dir/ssh/.ssh/config (Assuming structure)
# TO:   ssh/.ssh/config
if [[ -d "$HOME_FOLDERS_SRC" ]]; then
    echo "📂 Migrating Home Folders..."
    for folder in "$HOME_FOLDERS_SRC"/*; do
        [ -d "$folder" ] || continue
        package_name=$(basename "$folder")

        echo "   -> Processing $package_name"
        # Move the folder to root.
        # Note: You might need to check if the internal structure is correct
        # Stow expects: package_name/.ssh/config
        mv "$folder" .
    done
    rmdir "$HOME_FOLDERS_SRC" 2>/dev/null || echo "   (Note: $HOME_FOLDERS_SRC not empty, kept)"
else
    echo "👍 No '$HOME_FOLDERS_SRC' directory found, skipping."
fi

# 4. Migrate Cache Folders
# FROM: folders_to_cache_dir/wal
# TO:   wal/.cache/wal
if [[ -d "$CACHE_SRC" ]]; then
    echo "💾 Migrating Cache folders..."
    for folder in "$CACHE_SRC"/*; do
        [ -d "$folder" ] || continue
        package_name=$(basename "$folder")

        echo "   -> Processing $package_name"
        mkdir -p "$package_name/.cache"
        mv "$folder" "$package_name/.cache/"
    done
    rmdir "$CACHE_SRC" 2>/dev/null || echo "   (Note: $CACHE_SRC not empty, kept)"
else
    echo "👍 No '$CACHE_SRC' directory found, skipping."
fi

echo "-------------------------------------------------"
echo "✅ Migration Complete!"
echo "Check your folders. If they look good, run 'stow -nvt ~ package_name' to test."
echo "-------------------------------------------------"
