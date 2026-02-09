#!/bin/bash

INTERFACE="en0"
BYTES_IN_FILE="/tmp/sketchybar_bytes_in"
BYTES_OUT_FILE="/tmp/sketchybar_bytes_out"

read -r bytes_in bytes_out <<< "$(netstat -ibn | awk -v iface="$INTERFACE" '$1==iface && $3 ~ /\./ {print $7, $10; exit}')"

prev_in=$(cat "$BYTES_IN_FILE" 2>/dev/null || echo 0)
prev_out=$(cat "$BYTES_OUT_FILE" 2>/dev/null || echo 0)

echo "$bytes_in" > "$BYTES_IN_FILE"
echo "$bytes_out" > "$BYTES_OUT_FILE"

if [ "$prev_in" -gt 0 ] 2>/dev/null; then
    down=$(( (bytes_in - prev_in) / 2 ))
    up=$(( (bytes_out - prev_out) / 2 ))
else
    down=0
    up=0
fi

format_speed() {
    local bytes=$1
    if [ "$bytes" -ge 1048576 ]; then
        printf "%.1f MBps" "$(echo "$bytes / 1048576" | bc -l)"
    elif [ "$bytes" -ge 1024 ]; then
        printf "%d KBps" "$((bytes / 1024))"
    else
        printf "%03d Bps" "$bytes"
    fi
}

DOWN_LABEL=$(format_speed $down)
UP_LABEL=$(format_speed $up)

DOWN_COLOR=$( [ "$down" -gt 0 ] && echo "0xff50fa7b" || echo "0xffaaaaaa" )
UP_COLOR=$( [ "$up" -gt 0 ] && echo "0xff8be9fd" || echo "0xffaaaaaa" )

sketchybar \
    --set wifi.down label="$DOWN_LABEL" icon.color="$DOWN_COLOR" label.color="$DOWN_COLOR" \
    --set wifi.up label="$UP_LABEL" icon.color="$UP_COLOR" label.color="$UP_COLOR"
