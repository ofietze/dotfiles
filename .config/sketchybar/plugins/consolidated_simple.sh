#!/bin/bash

# Consolidated simple plugins for maximum performance
# Handles: aerospace, front_app, volume, battery

CONFIG_DIR="$HOME/.config/sketchybar"

# Batch all simple updates to reduce sketchybar calls
batch_updates=()

case "$NAME" in
    "space."*)
        # Aerospace workspace styling
        if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
            batch_updates+=(--set "$NAME" 
                background.color=0xff5e81ac 
                background.border_color=0xff81a1c1 
                label.color=0xffffffff)
        else
            batch_updates+=(--set "$NAME" 
                background.color=0xff3c3c3c 
                background.border_color=0xff666666 
                label.color=0xffffffff)
        fi
        ;;
        
    "front_app")
        if [ "$SENDER" = "front_app_switched" ]; then
            batch_updates+=(--set "$NAME" label="$INFO" font.style="Bold")
        fi
        ;;
        
    "battery")
        PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
        CHARGING="$(pmset -g batt | grep 'AC Power')"
        
        if [ "$PERCENTAGE" != "" ]; then
            # Icon based on battery level
            case "${PERCENTAGE}" in
                9[0-9]|100) ICON="" ;;
                [6-8][0-9]) ICON="" ;;
                [3-5][0-9]) ICON="" ;;
                [1-2][0-9]) ICON="" ;;
                *) ICON="" ;;
            esac
            
            # Color based on battery level
            if [[ "$CHARGING" != "" ]]; then
                ICON=""
                COLOR="0xff8be9fd"  # Cyan when charging
            elif [ "$PERCENTAGE" -ge 60 ]; then
                COLOR="0xff50fa7b"  # Green
            elif [ "$PERCENTAGE" -ge 30 ]; then
                COLOR="0xfff1fa8c"  # Yellow
            else
                COLOR="0xffff5555"  # Red
            fi
            
            batch_updates+=(--set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$COLOR" label.color="$COLOR")
        fi
        ;;
        
    "clock")
        # Progress bar for day completion
        hour=$(date '+%-H')
        minute=$(date '+%-M')
        total_minutes=$((hour * 60 + minute))
        pct=$((total_minutes * 100 / 1440))
        
        # Create progress bar (10 segments)
        filled=$((pct * 10 / 100))
        bar=""
        for ((i=0; i<10; i++)); do
            if [ $i -lt $filled ]; then
                bar+="▓"
            else
                bar+="░"
            fi
        done
        
        formatted_date=$(date '+%-d %b')
        time_part=$(date '+%H:%M')
        
        batch_updates+=(--set "$NAME" label="$formatted_date $bar ${pct}% $time_part")
        ;;
esac

# Execute all updates in one batch command
if [ ${#batch_updates[@]} -gt 0 ]; then
    sketchybar "${batch_updates[@]}"
fi
