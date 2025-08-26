#!/bin/bash

CONFIG_DIR="$HOME/.config/sketchybar"

update_space_icons() {
    local sid=$1
    local apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    # Check if space exists in sketchybar first
    if ! sketchybar --query space.$sid >/dev/null 2>&1; then
        # Space doesn't exist, create it
        create_workspace_item "$sid"
    fi

    # Show workspace if it has apps or is currently focused, otherwise hide it
    if [ "${apps}" != "" ] || [ "$sid" = "$(aerospace list-workspaces --focused)" ]; then
        sketchybar --set space.$sid drawing=on
        
        if [ "${apps}" != "" ]; then
            icon_strip=" "
            while read -r app; do
                icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
            done <<<"${apps}"
            sketchybar --set space.$sid label="$icon_strip"
        else
            sketchybar --set space.$sid label=""
        fi
    else
        # Hide empty inactive workspaces
        sketchybar --set space.$sid drawing=off
    fi
}

create_workspace_item() {
    local sid=$1
    
    # Determine monitor count
    monitor_count=$(aerospace list-monitors | wc -l | tr -d ' ')
    
    # Determine which display this workspace should be shown on
    display_id="1"
    
    if [ "$monitor_count" -eq 2 ]; then
        case "$sid" in
            [89]|10)
                display_id="2"
                ;;
            *)
                display_id="1"
                ;;
        esac
    fi
    
    sketchybar --add item space.$sid left \
      --set space.$sid display="$display_id" \
      --subscribe space.$sid aerospace_workspace_change \
      --set space.$sid \
      drawing=off \
      background.color=0x44ffffff \
      background.corner_radius=5 \
      background.drawing=on \
      background.border_color=0xAAFFFFFF \
      background.border_width=0 \
      background.height=20 \
      icon="$sid" \
      icon.padding_left=10 \
      icon.shadow.distance=4 \
      icon.shadow.color=0xA0000000 \
      label.font="sketchybar-app-font:Regular:16.0" \
      label.padding_right=20 \
      label.padding_left=0 \
      label.y_offset=-1 \
      label.shadow.drawing=off \
      label.shadow.color=0xA0000000 \
      label.shadow.distance=4 \
      click_script="aerospace workspace $sid" \
      script="$CONFIG_DIR/plugins/aerospace.sh $sid"
}

reconfigure_all_workspaces() {
    # Get monitor count
    monitor_count=$(aerospace list-monitors | wc -l | tr -d ' ')
    
    # Update display assignments and visibility for all existing spaces
    for sid in {1..10}; do
        # Skip workspace 0 - never show it
        if [ "$sid" = "0" ]; then
            continue
        fi
        
        if sketchybar --query space.$sid >/dev/null 2>&1; then
            # Check if workspace has apps or is focused
            apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
            focused_workspace=$(aerospace list-workspaces --focused)
            
            if [ "$monitor_count" -eq 1 ]; then
                # Show workspace on single monitor if it has apps or is focused
                if [ "${apps}" != "" ] || [ "$sid" = "$focused_workspace" ]; then
                    sketchybar --set space.$sid display=1 drawing=on
                else
                    sketchybar --set space.$sid drawing=off
                fi
            else
                # Two monitor setup: 1-7 on main, 8-10 on secondary
                case "$sid" in
                    [89]|10)
                        if [ "${apps}" != "" ] || [ "$sid" = "$focused_workspace" ]; then
                            sketchybar --set space.$sid display=2 drawing=on
                        else
                            sketchybar --set space.$sid drawing=off
                        fi
                        ;;
                    *)
                        if [ "${apps}" != "" ] || [ "$sid" = "$focused_workspace" ]; then
                            sketchybar --set space.$sid display=1 drawing=on
                        else
                            sketchybar --set space.$sid drawing=off
                        fi
                        ;;
                esac
            fi
        fi
    done
    
    # Always hide workspace 0 if it exists
    if sketchybar --query space.0 >/dev/null 2>&1; then
        sketchybar --set space.0 drawing=off
    fi
}

# If called with "reconfigure" argument, just reconfigure displays
if [ "$1" = "reconfigure" ]; then
    reconfigure_all_workspaces
    exit 0
fi

# Update only active workspaces (with windows) and the currently focused workspace
for sid in {1..10}; do
    # Skip workspace 0 - never show it
    if [ "$sid" = "0" ]; then
        continue
    fi
    
    # Check if workspace has windows or is currently focused
    apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
    focused_workspace=$(aerospace list-workspaces --focused)
    
    if [ "${apps}" != "" ] || [ "$sid" = "$focused_workspace" ]; then
        update_space_icons "$sid"
    else
        # Hide empty inactive workspaces if they exist
        if sketchybar --query space.$sid >/dev/null 2>&1; then
            sketchybar --set space.$sid drawing=off
        fi
    fi
done

# Also hide workspace 0 if it exists
if sketchybar --query space.0 >/dev/null 2>&1; then
    sketchybar --set space.0 drawing=off
fi

# Reconfigure displays based on current monitor setup
reconfigure_all_workspaces
