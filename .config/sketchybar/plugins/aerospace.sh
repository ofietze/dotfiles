#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME \
        background.color=0xff5e81ac \
        background.border_color=0xff81a1c1 \
        label.color=0xffffffff
else
    sketchybar --set $NAME \
        background.color=0xff3c3c3c \
        background.border_color=0xff666666 \
        label.color=0xffffffff
fi
