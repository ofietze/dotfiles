#!/usr/bin/env zsh
URL_FILE="/tmp/sketchybar_next_meeting_url"
[[ -f "$URL_FILE" ]] && open "$(cat "$URL_FILE")"
