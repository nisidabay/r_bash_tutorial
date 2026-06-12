#!/usr/bin/bash
#
# Show tmux commands

# Define regular expression concepts and their corresponding expressions
declare -a concepts
concepts=(
    "Attaches to session by the name session_name: tmux attach-session -t session_name"
    "Closes the current pane after prompting for confirmation: Ctrl+space  x"
    "Closes the current window after prompting for confirmation: Ctrl+space  &"
    "Combine and Convert all the panes into single window: Ctrl+space !"
    "Create new session with default session name: tmux new-session"
    "Create new session with default session name: tmux"
    "Creates a new window from within an existing tmux session:  Ctrl+space c"
    "Creates new session within an existing session: Ctrl+space new -s session_name"
    "Cycles through open panes: Ctrl+space o"
    "Cycles through the various pane layouts: Ctrl+space  Space"
    "Detaches from the session in thebackground: Ctrl+space d"
    "Displays a list of windows in the current session: Ctrl+space w"
    "Displays a prompt to rename a window: Ctrl+space ,"
    "Divides the current window in half vertically: Ctrl+space  %"
    "Enters command mode: Ctrl+space"
    "Go to the last window: Ctrl+space l"
    "Kills session by the name session_name: tmux kill-ses -t session_name"
    "Kills session by the name session_name: tmux kill-session -t session_name"
    "List active tmux sessions: Ctrl+space s"
    "List active tmux sessions: Ctrl+space list-sessions"
    "List active tmux sessions: Ctrl+space ls"
    "Momentarily displays pane numbers in each pane: Ctrl+space  q"
    "Move the current pane to left: Ctrl+space  {"
    "Move the current pane to right: Ctrl+space  }"
    "Move to the next session: Ctrl+space )"
    "Move to the previous session: Ctrl+space ("
    "Moves to the next window: Ctrl+space n"
    "Moves to the previous window: Ctrl+space p"
    "Rename the session name: Ctrl+space $"
    "Searches for a window that contains the text you specify: Ctrl+space f"
    "Selects windows by number: Ctrl+space 0..9"
    "Switch to the pane above the current pane: Ctrl+space  ⇑"
    "Switch to the pane below the current pane: Ctrl+space  ⇓"
    "Switch to the pane on the left side of the current pane: Ctrl+space  ⇐"
    "Switch to the pane on the right side of the current pane: Ctrl+space  ⇒"
    "To synchronise all the panes: Ctrl+space  setw synchronize-panes"
    "To turn off synchronisation between all the panes: Ctrl+space  setw"
    "Toggle pane zoom: Ctrl+space  z"
    'Divides the current window in half horizontally: Ctrl+space  "'
)

# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${concepts[@]}" | rofi -dmenu -p "Choose a tmux command:")

# Extract the regular expression from the user's choice
echo "$choice" | awk -F ":" '{print $2}' | xclip -selection clipboard
notify-send "Expression $choice copied to clipboard."
