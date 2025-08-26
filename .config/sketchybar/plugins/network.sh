#!/bin/sh

# Get primary network interface
INTERFACE=$(route -n get default 2>/dev/null | grep interface | awk '{print $2}')

# Fallback if no default route
if [ -z "$INTERFACE" ]; then
    INTERFACE="en0"
fi

# Get current bytes using a more reliable method
NETWORK_DATA=$(netstat -I "$INTERFACE" -b 2>/dev/null | tail -1)

if [ -z "$NETWORK_DATA" ]; then
    sketchybar --set "$NAME" label="No Network"
    exit 0
fi

DOWN_BYTES=$(echo "$NETWORK_DATA" | awk '{print $7}')
UP_BYTES=$(echo "$NETWORK_DATA" | awk '{print $10}')

# Store path for previous readings
PREV_FILE="/tmp/sketchybar_network_$INTERFACE"

# Read previous values
if [ -f "$PREV_FILE" ]; then
    PREV_DOWN=$(sed -n '1p' "$PREV_FILE" 2>/dev/null || echo "$DOWN_BYTES")
    PREV_UP=$(sed -n '2p' "$PREV_FILE" 2>/dev/null || echo "$UP_BYTES")
    PREV_TIME=$(sed -n '3p' "$PREV_FILE" 2>/dev/null || echo "$(date +%s)")
else
    PREV_DOWN=$DOWN_BYTES
    PREV_UP=$UP_BYTES
    PREV_TIME=$(date +%s)
fi

# Calculate current time
CURRENT_TIME=$(date +%s)
TIME_DIFF=$((CURRENT_TIME - PREV_TIME))

# Avoid division by zero
if [ "$TIME_DIFF" -eq 0 ] || [ "$TIME_DIFF" -lt 0 ]; then
    TIME_DIFF=2
fi

# Calculate speeds (bytes per second)
DOWN_SPEED=$(((DOWN_BYTES - PREV_DOWN) / TIME_DIFF))
UP_SPEED=$(((UP_BYTES - PREV_UP) / TIME_DIFF))

# Ensure speeds are non-negative
if [ "$DOWN_SPEED" -lt 0 ]; then DOWN_SPEED=0; fi
if [ "$UP_SPEED" -lt 0 ]; then UP_SPEED=0; fi

# Format speeds
format_speed() {
    local speed=$1
    if [ "$speed" -gt 1048576 ]; then
        echo "$((speed / 1048576))MB/s"
    elif [ "$speed" -gt 1024 ]; then
        echo "$((speed / 1024))KB/s"
    else
        echo "${speed}B/s"
    fi
}

DOWN_FORMATTED=$(format_speed $DOWN_SPEED)
UP_FORMATTED=$(format_speed $UP_SPEED)

# Update sketchybar
sketchybar --set "$NAME" label="↓$DOWN_FORMATTED ↑$UP_FORMATTED"

# Store current values for next time
{
    echo "$DOWN_BYTES"
    echo "$UP_BYTES" 
    echo "$CURRENT_TIME"
} > "$PREV_FILE"