#!/usr/bin/env zsh
# Maps aerospace monitor IDs to sketchybar display arrangement-ids.
# Outputs: AERO_ID:SKETCHYBAR_ID lines, one per monitor.
# Result is cached; the slow swift lookup only reruns when the monitor setup changes.

CACHE=/tmp/sketchybar_display_map

aero=$(aerospace list-monitors --format '%{monitor-id}|%{monitor-name}' 2>/dev/null)
sb=$(sketchybar --query displays 2>/dev/null | jq -r '.[] | "\(.["arrangement-id"]):\(.DirectDisplayID)"')
key="$aero"$'\n'"$sb"

if [[ -f $CACHE && -f $CACHE.key && "$(<$CACHE.key)" == "$key" ]]; then
  cat $CACHE
  exit 0
fi

# NSScreen name -> CGDirectDisplayID
typeset -A NAME_TO_DID
while IFS=: read -r name did; do
  NAME_TO_DID[$name]="$did"
done < <(swift -e '
import AppKit
for s in NSScreen.screens {
    let n = s.localizedName
    let d = s.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! UInt32
    print("\(n):\(d)")
}' 2>/dev/null)

# CGDirectDisplayID -> sketchybar arrangement-id
typeset -A DID_TO_ARR
while IFS=: read -r arr did; do
  DID_TO_ARR[$did]="$arr"
done <<<"$sb"

# aerospace monitor-id -> name -> CGDisplayID -> arrangement-id
out=""
while IFS='|' read -r aero_id aero_name; do
  [[ -z "$aero_id" ]] && continue
  out+="$aero_id:${DID_TO_ARR[${NAME_TO_DID[$aero_name]}]:-1}"$'\n'
done <<<"$aero"

print -rn -- "$out" > $CACHE
print -r -- "$key" > $CACHE.key
print -rn -- "$out"
