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
            case "${PERCENTAGE}" in
                9[0-9]|100) ICON="" ;;
                [6-8][0-9]) ICON="" ;;
                [3-5][0-9]) ICON="" ;;
                [1-2][0-9]) ICON="" ;;
                *) ICON="" ;;
            esac
            
            if [[ "$CHARGING" != "" ]]; then
                ICON=""
            fi
            
            batch_updates+=(--set "$NAME" icon="$ICON" label="${PERCENTAGE}%")
        fi
        ;;
        
    "clock")
        # Optimized clock function
        day=$(date '+%-d')
        case $day in
            1|21|31) ordinal_day="${day}st" ;;
            2|22) ordinal_day="${day}nd" ;;
            3|23) ordinal_day="${day}rd" ;;
            *) ordinal_day="${day}th" ;;
        esac
        
        formatted_date=$(date '+%a')
        time_part=$(date '+%B %H:%M')
        
        batch_updates+=(--set "$NAME" label="$formatted_date $ordinal_day $time_part")
        ;;
esac

# Execute all updates in one batch command
if [ ${#batch_updates[@]} -gt 0 ]; then
    sketchybar "${batch_updates[@]}"
fi
