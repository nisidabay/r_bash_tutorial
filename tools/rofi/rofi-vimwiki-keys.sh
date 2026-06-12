#!/usr/bin/env bash
#
# Show vimwiki main keys

declare -a keys
keys=(
    "Check links in wiki:VimwikiCheckLinks"
    "Colorize lines:VimwikiColorize"
    "Convert all to HTML:VimwikiAll2HTML"
    "Convert to HTML:Vimwiki2HTML"
    "Create tags:VimwikiGenerateTagLinks"
    "Create/update TOC: VimwikiTOC"
    "Delete wiki page:VimwikiDeleteFile"
    "Diary in tab:VimwikiTabMakeDiaryNote"
    "Diary index:VimwikiDiaryIndex"
    "Diary:VimwikiMakeDiaryNote"
    "Follow/create wiki:VimwikiFollowLink"
    "Goto wiki page by name:VimwikiGoto"
    "Index wiki in a tab:VimwikiTabIndex"
    "Index wiki:VimwikiIndex"
    "List of wikis:VimwikiUISelect"
    "Next unfinished task:VimwikiNextTask"
    "Open in browser:Vimwiki2HTMLBrowse"
    "Paste link to file:VimwikiPasteLink"
    "Paste url current file:VimwikiPasteUrl"
    "RSS feed from diary:VimwikiRss"
    "Rebuild tags:VimwikiRebuildTags"
    "Rename current wiki:VimwikiRenameFile"
    "Search tag:VimwikiSearchTags"
    "Toggle todo list:VimwikiToggleListItem"
    "Yesterday:VimwikiMakeYesterdayDiaryNote"
    "tomorrow:VimwikiMakeTomorrowDiaryNote"
)
# Use dmenu to display the list of concepts and get user input
printf '%s\n' "${keys[@]}" | rofi -dmenu -p "Some Vimwiki keys"
