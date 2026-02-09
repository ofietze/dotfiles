#!/usr/bin/env zsh
# Maps aerospace monitor IDs to sketchybar display arrangement-ids.
# Outputs: AERO_ID:SKETCHYBAR_ID lines, one per monitor.
# Usage: declare -A DISPLAY_MAP; while IFS=: read a s; do DISPLAY_MAP[$a]=$s; done < <(this_script)

# Get NSScreen name -> CGDirectDisplayID
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

# Get sketchybar DirectDisplayID -> arrangement-id
typeset -A DID_TO_ARR
while IFS=: read -r arr did; do
    DID_TO_ARR[$did]="$arr"
done < <(sketchybar --query displays 2>/dev/null | python3 -c "
import sys,json
for d in json.load(sys.stdin):
    print(f\"{d['arrangement-id']}:{d['DirectDisplayID']}\")
" 2>/dev/null)

# Map: aerospace monitor-id -> name -> CGDisplayID -> sketchybar arrangement-id
while IFS=$'\t' read -r aero_id aero_name; do
    cg_did="${NAME_TO_DID[$aero_name]}"
    sb_arr="${DID_TO_ARR[$cg_did]:-1}"
    echo "$aero_id:$sb_arr"
done < <(aerospace list-monitors --json 2>/dev/null | python3 -c "
import sys,json
for m in json.load(sys.stdin):
    print(f\"{m['monitor-id']}\t{m['monitor-name']}\")
" 2>/dev/null)
