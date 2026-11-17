#!/bin/bash
if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
  # Refresh workspace icons (catches closed windows / quit apps)
  "$HOME/.config/sketchybar/plugins/update_workspace_icons.sh" &
fi
