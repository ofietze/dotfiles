#!/bin/bash

# Monitor change detection script for sketchybar
CONFIG_DIR="$HOME/.config/sketchybar"

# Function to reconfigure workspaces based on monitor setup
reconfigure_workspaces() {
    "$CONFIG_DIR/plugins/update_workspace_icons.sh" reconfigure
}

# Call the reconfigure function
reconfigure_workspaces