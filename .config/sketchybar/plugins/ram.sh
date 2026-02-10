#!/bin/bash
page_size=$(sysctl -n hw.pagesize)
read -r active wired compressed <<< "$(vm_stat | awk -F: '/Pages active/{a=$2} /Pages wired/{w=$2} /Pages occupied by compressor/{c=$2} END{gsub(/[^0-9]/,"",a); gsub(/[^0-9]/,"",w); gsub(/[^0-9]/,"",c); print a,w,c}')"

total_mem=$(sysctl -n hw.memsize)
used_bytes=$(( (active + wired + compressed) * page_size ))
used_gb=$(echo "$used_bytes / 1073741824" | bc -l)
total_gb=$(echo "$total_mem / 1073741824" | bc -l)
pct=$((used_bytes * 100 / total_mem))

if [ "$pct" -ge 90 ]; then COLOR="0xffff5555"
elif [ "$pct" -ge 70 ]; then COLOR="0xffffb86c"
else COLOR="0xff50fa7b"; fi

sketchybar \
  --set ram.used label="$(printf '%.0fG' "$used_gb")" label.color="$COLOR" icon.color="$COLOR" \
  --set ram.total label="$(printf '%.0fG' "$total_gb")" icon="${pct}%" label.color="$COLOR" icon.color="$COLOR"
