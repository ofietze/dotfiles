#!/bin/bash
BORDER_COLOR="${2:-0xff666666}"
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.color=0xff5e81ac \
    background.border_color=0xff81a1c1 \
    label.color=0xffffffff
else
  sketchybar --set "$NAME" \
    background.color=0xff3c3c3c \
    background.border_color="$BORDER_COLOR" \
    label.color=0xffffffff
fi
