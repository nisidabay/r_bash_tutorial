#!/usr/bin/bash
#
# Show tmux commands

# Define regular expression concepts and their corresponding expressions
declare -a concepts
concepts=(
"Attaches to session by the name session_name: tmux a -t session_name"
"Attaches to session by the name session_name: tmux at -t session_name"
"Attaches to session by the name session_name: tmux attach -t session_name"
"Attaches to session by the name session_name: tmux attach-session -t session_name"
"Closes the current pane after prompting for confirmation: Ctrl+b  x"                            
"Closes the current window after prompting for confirmation: Ctrl+b  &"                            
"Closes the current window after prompting for confirmation: Ctrl+b  &"                            
"Closes the current window after prompting for confirmation: Ctrl+b &"     
"Closes the current window after prompting for confirmation: Ctrl+b x"     
"Combine and Convert all the panes into single window: Ctrl+b  !"                            
"Create new session with default session name: tmux new" 
"Create new session with default session name: tmux new-session" 
"Create new session with default session name: tmux" 
"Creates a new window from within an existing tmux session:  Ctrl+b c"     
"Creates new session within an existing session: Ctrl+b new -s session_name" 
"Cycles through open panes: Ctrl+b  o"                            
"Cycles through the various pane layouts: Ctrl+b  Space"                        
"Detaches from the session in thebackground: Ctrl+b d" 
"Displays a list of windows in the current session: Ctrl+b w"     
"Displays a prompt to rename a window: Ctrl+b ,"     
"Divides the current window in half vertically: Ctrl+b  %"                            
"Enters command mode: Ctrl+b" 
"Go to the last window: Ctrl+b l"     
"Kills session by the name session_name: tmux kill-ses -t session_name" 
"Kills session by the name session_name: tmux kill-session -t session_name" 
"List active tmux sessions: Ctrl+b s"
"List active tmux sessions: Ctrl+b list-sessions"
"List active tmux sessions: Ctrl+b ls"
"Momentarily displays pane numbers in each pane: Ctrl+b  q"                            
"Move the current pane to left: Ctrl+b  {"                            
"Move the current pane to right: Ctrl+b  }"                            
"Move to the next session: Ctrl+b )" 
"Move to the previous session: Ctrl+b (" 
"Moves to the next window: Ctrl+b n"     
"Moves to the previous window: Ctrl+b p"     
"Rename the session name: Ctrl+b $" 
"Searches for a window that contains the text you specify: Ctrl+b f"     
"Selects windows by number: Ctrl+b 0..9"  
"Switch to the pane above the current pane: Ctrl+b  ⇑"                            
"Switch to the pane below the current pane: Ctrl+b  ⇓"                            
"Switch to the pane on the left side of the current pane: Ctrl+b  ⇐"                            
"Switch to the pane on the right side of the current pane: Ctrl+b  ⇒"                            
"To synchronise all the panes: Ctrl+b  setw synchronize-panes"      
"To turn off synchronisation between all the panes: Ctrl+b  setw" 
"Toggle pane zoom: Ctrl+b  z"                            
'Divides the current window in half horizontally: Ctrl+b  "'                            
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${concepts[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "tmux commands")

# Extract the regular expression from the user's choice
expression=$(echo "$choice" | awk -F ":" '{print $2}')

if command -v mako &>/dev/null; then
   notify-send "Expression $expression copied to clipboard." 
   echo "$expression" | wl-copy
else
    echo "mako not found, skipping notification."
fi



