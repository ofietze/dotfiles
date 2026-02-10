#!/bin/bash

# RAM usage via vm_stat
page_size=$(sysctl -n hw.pagesize)
read -r free active speculative inactive wired compressed <<< "$(vm_stat | awk -F: '/Pages free/{f=$2} /Pages active/{a=$2} /Pages speculative/{s=$2} /Pages inactive/{i=$2} /Pages wired/{w=$2} /Pages occupied by compressor/{c=$2} END{gsub(/[^0-9]/,"",f); gsub(/[^0-9]/,"",a); gsub(/[^0-9]/,"",s); gsub(/[^0-9]/,"",i); gsub(/[^0-9]/,"",w); gsub(/[^0-9]/,"",c); print f,a,s,i,w,c}')"

total_mem=$(sysctl -n hw.memsize)
total_gb=$(echo "$total_mem / 1073741824" | bc -l)

used_pages=$((active + wired + compressed))
used_bytes=$((used_pages * page_size))
used_gb=$(echo "$used_bytes / 1073741824" | bc -l)

pct=$((used_bytes * 100 / total_mem))

# Swap
swap_used=$(sysctl -n vm.swapusage | awk '{for(i=1;i<=NF;i++) if($i=="used") print $(i+2)}' | tr -d ',')
[ -z "$swap_used" ] && swap_used=$(sysctl -n vm.swapusage | awk -F'used = ' '{print $2}' | awk '{print $1}')

LABEL=$(printf "%.1fG/%.0fG (%d%%)" "$used_gb" "$total_gb" "$pct")
[ -n "$swap_used" ] && [ "$swap_used" != "0M" ] && [ "$swap_used" != "0.00M" ] && LABEL="$LABEL sw:$swap_used"

if [ "$pct" -ge 90 ]; then
    COLOR="0xffff5555"
elif [ "$pct" -ge 70 ]; then
    COLOR="0xffffb86c"
else
    COLOR="0xff50fa7b"
fi

sketchybar --set "$NAME" label="$LABEL" icon.color="$COLOR" label.color="$COLOR"
