#!/usr/bin/env zsh

MEETING_URL_FILE="/tmp/sketchybar_next_meeting_url"

next=$(icalBuddy -n -li 1 -nc -nrd -ea -npn -ps "/ | /" -tf "%H:%M" -iep "title,datetime,notes,url" eventsToday 2>/dev/null)

if [[ -z "$next" ]]; then
  sketchybar --set $NAME label="All done 🎉" icon="󰃰"
  rm -f "$MEETING_URL_FILE"
  exit 0
fi

title="${next##* | }"
time_str="${next%% | *}"

# Extract meeting URL from notes/url fields
details=$(icalBuddy -n -li 1 -nc -nrd -ea -npn -iep "notes,url" eventsToday 2>/dev/null)
url=$(echo "$details" | grep -oE 'https://(teams\.microsoft\.com/l/meetup-join|zoom\.us/j|meet\.google\.com|webex\.com/meet)[^ )"<>]+' | head -1)
[[ -z "$url" ]] && url=$(echo "$details" | grep -oE 'https://[^ )"<>]+' | head -1)

if [[ -n "$url" ]]; then
  echo "$url" > "$MEETING_URL_FILE"
else
  rm -f "$MEETING_URL_FILE"
fi

now_epoch=$(date +%s)
meeting_epoch=$(date -j -f "%H:%M" "$time_str" +%s 2>/dev/null)

if [[ -z "$meeting_epoch" || "$meeting_epoch" -le "$now_epoch" ]]; then
  sketchybar --set $NAME label="Now: ${title:0:20}" icon="󰃰"
else
  mins=$(( (meeting_epoch - now_epoch) / 60 ))
  if [[ $mins -ge 60 ]]; then
    h=$(( mins / 60 ))
    m=$(( mins % 60 ))
    t="${h}h${m}m"
  else
    t="${mins}min"
  fi
  sketchybar --set $NAME label="${t} to: '${title:0:20}'" icon="󰃰"
fi
