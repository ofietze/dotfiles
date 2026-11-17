#!/bin/bash
# display_change handler: give aerospace a moment to see the new monitor layout, then refresh.
sleep 1
exec "$HOME/.config/sketchybar/plugins/update_workspace_icons.sh"
