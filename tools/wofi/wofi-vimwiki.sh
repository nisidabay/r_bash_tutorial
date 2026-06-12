#!/usr/bin/bash
#
# Show vimwiki main keys

declare -a keys 
keys=(
"Open index file of current wiki: VimwikiIndex"
"Open index file of current wiki in new tab : VimwikiTabIndex  "
"Display list of wikis and open selected index: VimwikiUISelect "
"Open diary index file of current wiki : VimwikiDiaryIndex "
"Open today's diary file of current wiki :  VimwikiMakeDiaryNote "
"Open today's diary file of current wiki in new tab: VimwikiTabMakeDiaryNote "
"Open yesterday's diary file of current wiki: VimwikiMakeYesterdayDiaryNote "
"Open tomorrow's diary file of current wiki: VimwikiMakeTomorrowDiaryNote "
"Follow/create wiki link: VimwikiFollowLink "
"Split and follow wiki link: VimwikiSplitLink "
"Vertical split and follow wiki link: VimwikiVSplitLink "
"Follow wiki link in new tab: VimwikiTabnewLink "
"Follow wiki link reuse tabs if open: VimwikiTabDropLink "
"Find next link in current page: VimwikiNextLink "
"Find previous link in current page: VimwikiPrevLink "
"Goto wiki page by name: VimwikiGoto "
"Delete current wiki page : VimwikiDeleteFile "
"Rename current wiki page: VimwikiRenameFile "
"Toggle checkbox in todo list: VimwikiToggleListItem "
"Goto next unfinished task: VimwikiNextTask "
"Convert current page to HTML: Vimwiki2HTML "
"Convert to HTML and open in browser: Vimwiki2HTMLBrowse "
"Convert all wiki pages to HTML: VimwikiAll2HTML "
"Generate RSS feed from diary: VimwikiRss "
"Check all links in wiki: VimwikiCheckLinks "
"Rebuild tags metadata: VimwikiRebuildTags "
"Search wiki pages for given tag: VimwikiSearchTags "
"Create overview of all wiki tags: VimwikiGenerateTagLinks "
"Colorize lines with given color: VimwikiColorize "
"Paste wiki link to current file: VimwikiPasteLink "
"Paste HTML url to current file: VimwikiPasteUrl "
"Create/update Table of Contents: VimwikiTOC "
)
# Use dmenu to display the list of concepts and get user input
choice=$(printf '%s\n' "${keys[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "Vimwiki Keys")

if command -v mako &>/dev/null; then
   notify-send "Expression $choice copied to clipboard." 
   echo "$choice " | wl-copy
else
    echo "mako not found, skipping notification."
fi



