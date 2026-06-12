#!/usr/bin/env zsh

CONFIG_DIR="$HOME/.config/sketchybar"

# Build aerospace -> sketchybar display mapping
typeset -A DISPLAY_MAP
while IFS=: read -r a s; do DISPLAY_MAP[$a]=$s; done < <("$CONFIG_DIR/plugins/display_map.sh")

# Cache aerospace data to avoid repeated calls
cache_aerospace_data() {
    export MONITOR_COUNT=$(aerospace list-monitors | wc -l | tr -d ' ')
    export FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
    
    # Build workspace info in one pass
    typeset -gA WORKSPACE_APPS
    typeset -gA WORKSPACE_EXISTS
    
    for sid in {1..10}; do
        [[ "$sid" == "0" ]] && continue
        
        apps=$(aerospace list-windows --workspace "$sid" 2>/dev/null | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
        WORKSPACE_APPS[$sid]="$apps"
        
        if sketchybar --query space.$sid >/dev/null 2>&1; then
            WORKSPACE_EXISTS[$sid]=1
        fi
    done
}

update_workspace_batch() {
    local batch_commands=()
    
    for sid in {1..10}; do
        [[ "$sid" == "0" ]] && continue
        
        local apps="${WORKSPACE_APPS[$sid]}"
        local should_show=false
        
        # Check if workspace should be visible
        if [[ -n "$apps" || "$sid" == "$FOCUSED_WORKSPACE" ]]; then
            should_show=true
        fi
        
        if [[ "${WORKSPACE_EXISTS[$sid]}" == "1" ]]; then
            if $should_show; then
                # Build icon strip efficiently
                local icon_strip=""
                if [[ -n "$apps" ]]; then
                    icon_strip=" "
                    while IFS= read -r app; do
                        [[ -n "$app" ]] && icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
                    done <<<"$apps"
                fi
                
                batch_commands+=(--set space.$sid drawing=on label="$icon_strip")
            else
                batch_commands+=(--set space.$sid drawing=off)
            fi
        elif $should_show; then
            # Create new workspace
            create_workspace_item "$sid"
        fi
    done
    
    # Hide workspace 0 if it exists
    if sketchybar --query space.0 >/dev/null 2>&1; then
        batch_commands+=(--set space.0 drawing=off)
    fi
    
    # Execute all updates in one command
    [[ ${#batch_commands[@]} -gt 0 ]] && sketchybar "${batch_commands[@]}"
}

create_workspace_item() {
    local sid=$1
    local display_id="1"
    
    # Query aerospace for actual monitor, then translate to sketchybar display
    for mid in $(aerospace list-monitors | awk '{print $1}'); do
        if aerospace list-workspaces --monitor "$mid" | grep -qx "$sid"; then
            display_id="${DISPLAY_MAP[$mid]:-1}"
            break
        fi
    done
    
    sketchybar --add item space.$sid left \
      --set space.$sid display="$display_id" \
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
            script="$CONFIG_DIR/plugins/aerospace.sh $sid" \
      --subscribe space.$sid aerospace_workspace_change
    
    WORKSPACE_EXISTS[$sid]=1
}

reconfigure_displays() {
    cache_aerospace_data
    
    # Refresh display mapping
    typeset -A DISPLAY_MAP
    while IFS=: read -r a s; do DISPLAY_MAP[$a]=$s; done < <("$CONFIG_DIR/plugins/display_map.sh")
    
    # Build workspace -> sketchybar display map
    typeset -A WS_DISPLAY
    for mid in $(aerospace list-monitors | awk '{print $1}'); do
        local sb_display="${DISPLAY_MAP[$mid]:-1}"
        for ws in $(aerospace list-workspaces --monitor "$mid"); do
            WS_DISPLAY[$ws]="$sb_display"
        done
    done
    
    local batch_commands=()
    for sid in {1..10}; do
        [[ "$sid" == "0" ]] && continue
        [[ "${WORKSPACE_EXISTS[$sid]}" != "1" ]] && continue
        
        local apps="${WORKSPACE_APPS[$sid]}"
        local display_id="${WS_DISPLAY[$sid]:-1}"
        local should_show=false
        
        if [[ -n "$apps" || "$sid" == "$FOCUSED_WORKSPACE" ]]; then
            should_show=true
        fi
        
        if $should_show; then
            batch_commands+=(--set space.$sid display=$display_id drawing=on)
        else
            batch_commands+=(--set space.$sid drawing=off)
        fi
    done
    
    [[ ${#batch_commands[@]} -gt 0 ]] && sketchybar "${batch_commands[@]}"
}

# Main execution
if [[ "$1" == "reconfigure" ]]; then
    reconfigure_displays
    exit 0
fi

cache_aerospace_data
update_workspace_batch