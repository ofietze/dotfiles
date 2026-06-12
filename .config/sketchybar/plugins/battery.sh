#!/bin/bash
PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ -n "$PERCENTAGE" ]; then
  if [ -n "$CHARGING" ]; then
    ICON=""; COLOR="0xff8be9fd"
  elif [ "$PERCENTAGE" -ge 60 ]; then
    COLOR="0xff50fa7b"
  elif [ "$PERCENTAGE" -ge 30 ]; then
    COLOR="0xfff1fa8c"
  else
    COLOR="0xffff5555"
  fi
  sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$COLOR" label.color="$COLOR"
fi
