#!/bin/bash

# Script to watch for monitor changes and trigger sketchybar updates
CACHE_FILE="/tmp/sketchybar_monitor_count"

# Get current monitor count
current_monitors=$(aerospace list-monitors | wc -l | tr -d ' ')

# Read previous monitor count
if [ -f "$CACHE_FILE" ]; then
    previous_monitors=$(cat "$CACHE_FILE")
else
    previous_monitors=0
fi

# If monitor count changed, trigger display change event
if [ "$current_monitors" != "$previous_monitors" ]; then
    echo "$current_monitors" > "$CACHE_FILE"
    sketchybar --trigger display_change
    # Also run the workspace reconfiguration
    ~/.config/sketchybar/plugins/update_workspace_icons.sh reconfigure
fi