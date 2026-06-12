#!/usr/bin/env bash
#
# Color picker wrapper
# Show color_picker.py
set -eou pipefail
# Set environment variables and navigate to the application directory
COLOR_PICKER_APP_DIR="$HOME/bin/color_picker"
SCRIPT_NAME="color_picker.py"

# Navigate to the application directory and source the virtual environment
cd "$COLOR_PICKER_APP_DIR" || exit
source venv/bin/activate

# Run the script
python "$SCRIPT_NAME"
