#!/bin/bash

# Optimized network plugin with reduced overhead and caching

# Allow execution on timer updates (no SENDER) and manual calls

# Cache file locations
CACHE_DIR="/tmp/sketchybar_cache"
mkdir -p "$CACHE_DIR"

INTERFACE_CACHE="$CACHE_DIR/network_interface"
PREV_FILE="$CACHE_DIR/network_data"

# Get network interface (cached)
if [[ -f "$INTERFACE_CACHE" && -s "$INTERFACE_CACHE" ]]; then
    INTERFACE=$(cat "$INTERFACE_CACHE")
else
    INTERFACE=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}' | head -1)
    [[ -z "$INTERFACE" ]] && INTERFACE="en0"
    echo "$INTERFACE" > "$INTERFACE_CACHE"
fi

# Get network stats efficiently
NETWORK_DATA=$(netstat -I "$INTERFACE" -b 2>/dev/null | tail -1)
[[ -z "$NETWORK_DATA" ]] && {
    sketchybar --set "$NAME" label="No Network"
    exit 0
}

# Extract bytes efficiently
read -r _ _ _ _ _ _ DOWN_BYTES _ _ UP_BYTES _ <<< "$NETWORK_DATA"

CURRENT_TIME=$(date +%s)

# Read previous data
if [[ -f "$PREV_FILE" ]]; then
    IFS=$'\n' read -d '' -r PREV_DOWN PREV_UP PREV_TIME < "$PREV_FILE"
else
    PREV_DOWN=$DOWN_BYTES
    PREV_UP=$UP_BYTES
    PREV_TIME=$CURRENT_TIME
fi

# Calculate speeds
TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
[[ $TIME_DIFF -le 0 ]] && TIME_DIFF=2

DOWN_SPEED=$(((DOWN_BYTES - PREV_DOWN) / TIME_DIFF))
UP_SPEED=$(((UP_BYTES - PREV_UP) / TIME_DIFF))

# Ensure non-negative
[[ $DOWN_SPEED -lt 0 ]] && DOWN_SPEED=0
[[ $UP_SPEED -lt 0 ]] && UP_SPEED=0

# Format speeds efficiently
format_speed() {
    local speed=$1
    if [[ $speed -gt 1048576 ]]; then
        echo "$((speed / 1048576))MB/s"
    elif [[ $speed -gt 1024 ]]; then
        echo "$((speed / 1024))KB/s"
    else
        echo "${speed}B/s"
    fi
}

DOWN_FORMATTED=$(format_speed $DOWN_SPEED)
UP_FORMATTED=$(format_speed $UP_SPEED)

# Update display
sketchybar --set "$NAME" label="↓$DOWN_FORMATTED ↑$UP_FORMATTED"

# Cache current values atomically
{
    echo "$DOWN_BYTES"
    echo "$UP_BYTES"
    echo "$CURRENT_TIME"
} > "$PREV_FILE"