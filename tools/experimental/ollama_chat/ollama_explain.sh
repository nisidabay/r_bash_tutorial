#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Ollama Explains: A dmenu/fuzzel based chat client for local LLMs
#
# This script provides an interactive command-line and menu-driven interface
# for chatting with local language models via the Ollama server. It is designed
# to be lightweight and work seamlessly in both X11 and Wayland environments.
#
# Features:
# - Environment-aware: Automatically uses `dmenu` on X11 and `fuzzel` on Wayland.
# - Clipboard integration: Copies AI responses to the clipboard (`xsel` or `wl-copy`).
# - Chat history: Saves conversations and allows viewing and recovering past responses.
# - Model switching: Allows changing the active Ollama model on the fly.
# - Multi-line input support.
# - External configuration file support (`.ollama_explain.conf`).
#
# Dependencies:
# - `ollama`: The local LLM server.
# - `dmenu` (X11) or `fuzzel` (Wayland): For interactive menus.
# - `xsel` (X11) or `wl-copy` (Wayland): For clipboard access.
# - An editor (`nvim`, `vim`, etc.) and a pager (`less`, `vim`, etc.).
# ==============================================================================

# --- Configuration ---
# It's good practice to define the script's directory relative to the script itself.
# SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly SCRIPT_DIR="$HOME/bin/ollama_chat/"
readonly CONFIG_FILE="$SCRIPT_DIR/.ollama_explain.conf"
readonly CHAT_HISTORY_FILE="$SCRIPT_DIR/.ollama_explain_history.log"
readonly VERSION='1.0.2'

# Load configuration if it exists.
if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
fi

# Set default values if not provided in the config file.
MODEL="${MODEL:-qwen2.5-coder:7b}"
EDITOR="${EDITOR:-nvim}"
PAGER="${PAGER:-less}" # Using `less` is a safer default pager.

# --- Setup and Validation ---

# Ensure the chat history file exists.
touch "$CHAT_HISTORY_FILE"

# Checks for required command-line tools.
check_dependencies() {
    local -a missing_deps=()
    for dep in "$@"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if ((${#missing_deps[@]} > 0)); then
        echo "❌ Missing Dependencies: ${missing_deps[*]}" >&2
        echo "   Please install them to continue." >&2
        exit 1
    fi
}

# --- Environment-Specific Setup (Wayland vs. X11) ---
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    # Wayland Environment
    check_dependencies "foot" "wl-copy" "fuzzel"
    TERMINAL="foot"
    COPY_CMD="wl-copy"
    menu() {
        fuzzel --dmenu --match-mode=exact -p "$1" | tr -d '\r'
    }
else
    # X11 Environment
    check_dependencies "st" "xsel" "dmenu"
    TERMINAL="st"
    COPY_CMD="xsel -ib"
    # Source dmenu theme if available.
    if [[ -f "${HOME}/bin/dmenu_wal.sh" ]]; then
        # shellcheck disable=SC1090
        source "${HOME}/bin/dmenu_wal.sh"
    fi
    menu() {
        dmenu -c -i -l 20 "${DMENU_APPEARANCE[@]:-}" -p "$1" | tr -d '\r'
    }
fi

# --- Core Functions ---

# Shuts down the Ollama server process.
kill_ollama_server() {
    # It might be better to use `ollama stop` if available, or check if sudo is truly needed.
    if pgrep -x "ollama" &>/dev/null; then
        echo "🛑 Shutting down Ollama server..."
        if sudo pkill ollama; then
            echo "✅ Ollama server has been shut down."
        else
            echo "❌ Failed to shut down Ollama server." >&2
        fi
    else
        echo "🔴 Ollama server is not running."
    fi
}

# Gets the desired model, either from config or by prompting the user.
get_model() {
    # If a model is already defined in the config, use it.
    if [[ -n "${MODEL:-}" ]]; then
        echo "$MODEL"
        return
    fi

    # Otherwise, fetch the list of available models.
    local models_list
    models_list=$(ollama list | awk 'NR>1 {print $1}')
    if [[ -z "$models_list" ]]; then
        echo "❌ Error: No Ollama models available. Run 'ollama pull <model>' to get one." >&2
        exit 1
    fi

    local selected_model
    selected_model=$(echo "$models_list" | menu "Select Ollama Model:")
    if [[ -z "$selected_model" ]]; then
        echo "❌ Error: No model selected. Exiting." >&2
        exit 1
    fi
    echo "$selected_model"
}

# Displays the help menu.
show_menu() {
    cat <<EOF
---------------------------------------------------
--- Ollama Explains Menu (v$VERSION) ---
---------------------------------------------------
Commands:
  !clear      - Clear the current chat history.
  !history    - View the chat history in a pager.
  !kill       - Stop the Ollama server and exit.
  !menu       - Show this help menu.
  !new_chat   - Start a new chat (clears history).
  !recover    - Copy a line from history to the clipboard.
  !switch     - Switch to a different AI model.
  exit | quit - Quit the script.

Multi-line Input:
  Paste text and press Ctrl+D on a new line to submit.
---------------------------------------------------
EOF
}

# --- Command Handlers ---

handle_history() {
    if [[ -s "$CHAT_HISTORY_FILE" ]]; then
        cat "$CHAT_HISTORY_FILE" | "$PAGER"
    else
        echo "📜 History is empty."
    fi
}

handle_recover() {
    if [[ -s "$CHAT_HISTORY_FILE" ]]; then
        # It might be useful to filter out the "AI:" and "You:" prefixes here.
        cat "$CHAT_HISTORY_FILE" | menu "Select line to copy:" | "$COPY_CMD"
        echo "📋 Selected line copied to clipboard."
    else
        echo "📜 History is empty."
    fi
}

handle_clear() {
    # The `:` command is a no-op, and `> file` truncates the file.
    : >"$CHAT_HISTORY_FILE"
    echo "📜 History has been cleared."
}

# Handles the main chat interaction with the Ollama model.
handle_chat() {
    local user_prompt="$1"
    local conversation_history=""
    local full_prompt

    # Read the existing conversation history.
    [[ -s "$CHAT_HISTORY_FILE" ]] && conversation_history=$(<"$CHAT_HISTORY_FILE")

    # Construct the full prompt sent to the model.
    full_prompt="$conversation_history\n\nUser: $user_prompt"

    echo "🧠 Thinking..."

    # Run Ollama and clean the response.
    # The sed command attempts to remove terminal control characters.
    local response
    response=$(ollama run "$MODEL" "$full_prompt" | sed 's/.*\r//; s/\x1b\[[0-9;]*[mGKH]//g')

    if [[ -n "$response" ]]; then
        # Trim leading newlines for cleaner output.
        response="${response#"${response%%[![:space:]]*}"}"
        local formatted_response="🤖 AI: $response"
        echo -e "\n$formatted_response"

        # Copy the raw response to the clipboard.
        echo "$response" | "$COPY_CMD"
        echo -e "\n-----------------------------------------------\n📋 Response copied to clipboard.\n📜 Use !history to view the full conversation.\n-----------------------------------------------"

        # Append the user's prompt and the AI's response to the history file.
        printf "👦 You: %s\n\n%s\n\n" "$user_prompt" "$formatted_response" >>"$CHAT_HISTORY_FILE"
    else
        echo "⚠️ Warning: Ollama returned an empty response."
    fi
}

# --- Main Execution Loop ---
main() {
    check_dependencies "ollama"
    MODEL=$(get_model)
    [[ -z "$MODEL" ]] && exit 1 # Exit if get_model failed.

    echo -e "-------------------------------------\n🦙 Ollama Explains. Local chat 🦙\n🧠 Using model: '$MODEL'\n⌨  Type '!menu' for commands.\n-------------------------------------\n"

    while true; do
        # Use `read -e` for readline support (history, editing).
        read -rep "👦 You: " user_input

        # Handle multi-line input (e.g., from a paste).
        # `read -t 0` checks for buffered input without blocking.
        if read -t 0; then
            local rest_of_input
            rest_of_input=$(cat)
            user_input+=$'\n'"$rest_of_input"
            handle_chat "$user_input"
            continue
        fi

        # Handle single-line commands.
        case "$user_input" in
            exit | quit) echo "👋 Goodbye!"; break ;;
            "!menu") show_menu ;;
            "!history") handle_history ;;
            "!recover") handle_recover ;;
            "!clear"|"!new_chat") handle_clear; [[ "$user_input" == "!new_chat" ]] && clear ;;
            "!kill") kill_ollama_server; break ;;
            "!switch")
                local OLD_MODEL="$MODEL"
                MODEL=$(get_model)
                echo "🧠 Switched to '$MODEL'."
                # Stop the old model to free up memory.
                ollama stop "$OLD_MODEL" &>/dev/null
                ;;
            "") continue ;; # Ignore empty input.
            *) handle_chat "$user_input" ;;
        esac
    done
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
