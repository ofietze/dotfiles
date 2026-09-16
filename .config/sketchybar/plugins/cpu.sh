#!/bin/bash
# CPU usage — matches ram.sh conventions (percentage-driven, threshold colors)

# top -l 2 gives two samples; the 2nd is the real instantaneous reading.
# Line looks like: "CPU usage: 4.76% user, 9.52% sys, 85.71% idle"
read -r usr sys <<< "$(top -l 2 -n 0 | awk -F'[:,]' '/CPU usage/{u=$2; s=$3} END{gsub(/[^0-9.]/,"",u); gsub(/[^0-9.]/,"",s); print u, s}')"

# Total busy = user + sys, rounded to an integer percent
pct=$(printf '%.0f' "$(echo "$usr + $sys" | bc -l)")
[ -z "$pct" ] && pct=0

# Load average (1-minute) for the second line
load=$(sysctl -n vm.loadavg | awk '{print $2}')

if [ "$pct" -ge 90 ]; then COLOR="0xffff5555"
elif [ "$pct" -ge 70 ]; then COLOR="0xffffb86c"
else COLOR="0xff50fa7b"; fi

sketchybar \
  --set cpu.used  label="${pct}%"  label.color="$COLOR" icon.color="$COLOR" \
  --set cpu.total label="$load"    label.color="$COLOR" icon.color="$COLOR"
