#!/bin/bash
# Modified by nisidabay. Adapted to my needs:
# wofi notes menu editor

# Script name: wofi-note
#   1. Add individual notes.
#   2. Create and edit notes at the same time
#
# Description: Store multiple one-line texts or codes and copy one of them when needed.
# Dependencies: dmenu, fzf, rofi, xclip
#
# Authors:      Fawzakin
#               Derek Taylor
#
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
#
#!/usr/bin/bash
set -euo pipefail

notes_dir="$HOME/notes"

cp2cb() {
	# Copy the selected note to the clipboard
	case "$XDG_SESSION_TYPE" in
	    'x11') xclip -r -selection clipboard ;;
	    'wayland') wl-copy -n ;;
	    *) err "Unknown display server" ;;
	esac
}

main() {
	# Picking our options.

    choice=$(printf '%s\n' "Copy note" "New note" "Delete note" "Edit note" "Quit" | \
         $WMENU --prompt "Notes:" "$@")


	# Choose what we should do with our choice.
	case "$choice" in
	'Copy note')
		note_pick=$(${WMENU} 'Copy:' "$@" < <(ls "${notes_dir}"))

		note_file="$notes_dir/$note_pick"
		[ -n "${note_pick}" ] && cat <"${note_file}" | cp2cb && notify-send -u normal "Note copied" "${note_pick}"
		;;
	'New note')
		note_filename=$(echo "" | ${WMENU} 'Enter new note:' "$@")
		note_filename=$(echo "$note_filename" | sed 's/[^a-zA-Z0-9]/_/g') # Remove special characters and replace with underscores
		note_file="$notes_dir/$note_filename.txt"
		touch "${note_file}"
		[ -n "${note_file}" ] && "$ALTERNATE_TERMINAL" -e sh -c "\"$EDITOR\" \"${note_file}\" && \"$SHELL\"" && notify-send -u normal "Note created" "$note_filename"
		;;
	'Delete note')
		note_del=$(${WMENU} 'Delete:' "$@" < <(find "$notes_dir" -type f -printf "%f\n"))
		note_file="$notes_dir/$note_del"
		[ -n "${note_del}" ] && rm "$note_file" && notify-send -u normal "Note deleted" "${note_del}"
		;;

	'Edit note')
		note_edit=$(${WMENU} 'Edit:' "$@" < <(ls "${notes_dir}"))
		note_file="${notes_dir}/${note_edit}"
		[ -n "${note_edit}" ] && "$ALTERNATE_TERMINAL" -e sh -c "\"$EDITOR\" \"${note_file}\" && \"$SHELL\"" && notify-send -u normal "Note edited"
		# For xfce4-terminal
		#[ -n "${note_edit}" ] && "$TERMINAL" -e "\"$EDITOR\" \"${note_file}\" && \"$SHELL\"" && notify-send -u normal "Note edited"

		;;

	'Quit')
		echo "Program terminated." && exit 0
		;;
	*)
		exit 0
		;;
	esac
}

# If script is run with '-d', it will use 'dmenu'
# If script is run with '-f', it will use 'fzf'
# If script is run with '-d', it will use 'rofi'
# If script is run with '-w', it will use 'wofi'
while getopts "dfrwh" arg 2>/dev/null; do
	case "${arg}" in
	d)
		# shellcheck disable=SC2153
		WMENU=${DMENU}
		[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
	    noOpt=1
		;;
	f)
		# shellcheck disable=SC2153
		WMENU=${FMENU}
		[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
	    noOpt=2
		;;
	r)
		# shellcheck disable=SC2153
		WMENU=${RMENU}
		[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "@"
	    noOpt=3
		;;
	w)
		# shellcheck disable=SC2153
		WMENU=${WMENU}
		[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "@"
	    noOpt=4
		;;
	h)
		help
		;;
	*)
		printf '%s\n' "Error: invalid option" "Type $(basename "$0") -h for help"
		;;
	esac
	noOpt=0
done
noOpt=4
# If script is run with NO argument, it will use 'dmenu'
[ $noOpt = 4 ] && WMENU=${WMENU} && [[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"

