#!/bin/bash
#
# Mail a video link

# Sends an email using the `neomutt` email client.
#
# Usage:
# bash mail.sh <video_link> <text> <subject> <email_address>
#
# Args:
# <video_link> - The YouTube link of the video to be sent in the email body.
# <text> - The text to be sent in the email body.
# <subject> - The subject line of the email.
# <email_address> - The email address to send the email to.

mail_link() {
	video_link=$1
	subject=$2
	mail=$3
	text=$4

	if [[ -n ${subject} && -n ${mail} && -n ${text} ]]; then
		echo -e "${video_link}\n\n${text}" | neomutt -s "${subject}" "${mail}"
	else
		echo "Missing arguments"
		exit 1
	fi
}
mail_link "$@"
