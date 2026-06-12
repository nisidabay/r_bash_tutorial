#!/usr/bin/env bash
#
# Wrapper script for Enhanced Dork Search Tool
# This script activates the virtual environment and runs the enhanced dork search tool

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# If this script is in ~/bin, the actual project is in ~/bin/dork_search
if [[ "$SCRIPT_DIR" == */bin && "$SCRIPT_DIR" != */dork_search ]]; then
    PROJECT_DIR="$SCRIPT_DIR/dork_search"
else
    PROJECT_DIR="$SCRIPT_DIR"
fi

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Dork Search project directory not found at $PROJECT_DIR"
    echo "Please ensure the project is installed in ~/bin/dork_search/"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "$PROJECT_DIR/env" ]; then
    echo "Error: Virtual environment not found in $PROJECT_DIR"
    echo "Please run setup_environment.sh first:"
    echo "  cd $PROJECT_DIR && ./setup_environment.sh"
    exit 1
fi

# Change to project directory
cd "$PROJECT_DIR"

# Activate virtual environment
source env/bin/activate

# Check if enhanced dork script exists
if [ ! -f "dork_enhanced.py" ]; then
    echo "Error: dork_enhanced.py not found in $PROJECT_DIR"
    echo "Falling back to original dork.py..."
    if [ ! -f "dork.py" ]; then
        echo "Error: No dork search script found"
        exit 1
    fi
    SCRIPT_NAME="dork.py"
else
    SCRIPT_NAME="dork_enhanced.py"
fi

echo "🔍 Starting Enhanced Google Dork Search Tool..."
echo "📚 Educational OSINT & Advanced Search Learning Platform"
echo ""
echo "🌐 The tool will open in your default web browser"
echo "📝 Use Ctrl+C to stop the server when done"
echo ""

# Run the streamlit app
streamlit run "$SCRIPT_NAME" --browser.gatherUsageStats false

# Deactivate virtual environment
deactivate