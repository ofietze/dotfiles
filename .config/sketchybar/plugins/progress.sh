#!/bin/bash
hour=$(date '+%-H')
minute=$(date '+%-M')
current=$((hour * 60 + minute))
ws=540 we=1020

if [ $current -lt $ws ]; then pct=0
elif [ $current -ge $we ]; then pct=100
else pct=$(( (current - ws) * 100 / (we - ws) )); fi

filled=$((pct * 10 / 100))
bar=""
for ((i=0; i<10; i++)); do
  [ $i -lt $filled ] && bar+="▓" || bar+="░"
done

sketchybar --set "$NAME" label="$(date '+%-d %b') $bar ${pct}%"
