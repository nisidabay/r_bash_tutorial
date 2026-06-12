#!/usr/bin/env bash
#
# list of videos they can select and watch without a browser.
#
# From Luke Smith Page and Youtube
# Checks if the programs passed as strings are installed
chk_dependencies() {
    local -a dependencies_array=("$@")
    local -a missing=()

    for program in "${dependencies_array[@]}"; do
        if ! command -v "$program" >/dev/null; then
            missing+=("$program")
        fi
    done

    if [[ "${#missing[@]}" -gt 0 ]]; then
        local missing_programs="${missing[*]}"
        echo "Install the missing dependencies before continuing: $missing_programs"
        notify-send "Missing Dependencies" \
            "Install the following programs before continuing: $missing_programs" \
            --icon=dialog-warning
        exit 1
    fi
}

# Example
chk_dependencies "rofi" "mpv" "notify-send" "gum"

declare -a vidlist="
calcurse (calendar):https://videos.lukesmith.xyz/videos/watch/4b937e8b-7654-46e3-8d01-79392ec5b3d1
chatGPT (API in Python):https://www.youtube.com/watch?v=XxIfSkkyAaQ
colorschemes with pywal:https://videos.lukesmith.xyz/videos/watch/1b476003-61b2-4609-ac4b-820c3d128643
dwm (window manager):https://videos.lukesmith.xyz/videos/watch/f6b78db7-b368-4647-bc64-28c08fff1988
dwmblocks (status bar):https://videos.lukesmith.xyz/w/mmxHMbqZZEr5FManB57Yy1
gpg keys:https://videos.lukesmith.xyz/videos/watch/040f5530-4830-4583-9ddc-2080b421531b
i3 (old window manager):https://videos.lukesmith.xyz/videos/watch/b861525c-7ada-40ee-a2bb-b5e1ffe0f48b
lf (file manager):https://videos.lukesmith.xyz/w/rKeHsF5ZHDNDbR1buUKB1c
luks (usb):https://videos.lukesmith.xyz/w/qxMiq53aTieALZwumuxG6G
ncmpcpp (music player):https://videos.lukesmith.xyz/videos/watch/b5ac6f0d-a220-4433-88e3-e98fc791dc0a
neomutt (email):https://videos.lukesmith.xyz/videos/watch/83122e83-52d9-4278-ae1a-7d1beeb50c8e
newsboat (RSS reader):https://videos.lukesmith.xyz/videos/watch/bd2c3fff-40fa-47ea-aa98-5b1ec0c903b6
pacman (installing/managing programs):https://videos.lukesmith.xyz/videos/watch/8e7cadb9-0fed-47ce-a2a8-6635fa48614b
pass (password manager):https://videos.lukesmith.xyz/videos/watch/432fc942-5e28-4682-9beb-f5cb237a1dd6
protonvpn:https://www.youtube.com/watch?v=vBpZ_i_P63M&t=24s
python (create package):https://www.youtube.com/watch?v=5KEObONUkik
rich:https://www.youtube.com/watch?v=4zbehnz-8QU
sed:https://www.youtube.com/watch?v=V-I3OLB8gy0
sequoia (mac):https://www.youtube.com/watch?v=rfa2aSm7OxQ
st (terminal):https://videos.lukesmith.xyz/videos/watch/efddd39d-bac5-4599-b572-177beb4ce6e8
sxiv (image viewer):https://videos.lukesmith.xyz/videos/watch/ad4c8d85-90c3-4f3d-a1f3-89129e64a3c2
urlview:https://videos.lukesmith.xyz/videos/watch/31a4918f-633b-4bd6-b08e-956ac75d0324
vi mode in shell:https://videos.lukesmith.xyz/videos/watch/228aa50c-836f-456f-9f0d-a45157fe4313
vimwiki (usage and setup):https://www.youtube.com/watch?v=nQSUyc2OQ48&t=287s
zathura (pdf viewer):https://videos.lukesmith.xyz/videos/watch/c780f75a-11f6-48a9-a191-d079ebc36ea4
"

# Show titles in rofi and get the corresponding URL
title=$(echo "$vidlist" | grep : | cut -d':' -f1 | rofi -dmenu -p "Watch a video?")

# Extract and play the URL
if [ -n "$title" ]; then
    url=$(echo "$vidlist" | grep "^$title:" | grep -o 'https:.*' | tr -d '\n\r')
    if [ -n "$url" ]; then
        gum style \
            --border rounded \
            --align left \
            --width 50 \
            --foreground 212 \
            "Loading $title video. Wait ..."
        mpv --no-terminal "$url"
    fi
fi
