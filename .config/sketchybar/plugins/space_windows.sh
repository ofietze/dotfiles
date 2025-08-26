#!/bin/bash

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # Call the full update script which handles visibility and icons properly
  "$CONFIG_DIR/plugins/update_workspace_icons.sh"
fi
