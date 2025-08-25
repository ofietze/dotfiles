#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

#!/bin/sh

# Function to get ordinal suffix
get_ordinal() {
    day=$1
    case $day in
        1|21|31) echo "${day}st" ;;
        2|22) echo "${day}nd" ;;
        3|23) echo "${day}rd" ;;
        *) echo "${day}th" ;;
    esac
}

day=$(date '+%-d')
ordinal_day=$(get_ordinal $day)
formatted_date=$(date '+%a')

sketchybar --set "$NAME" label="$formatted_date $ordinal_day $(date '+%B %H:%M')"

