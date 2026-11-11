#!/bin/bash

# Check if brew update/upgrade has been run in the last 14 days.
# Tracks its own timestamps — no filesystem scanning needed.
# Fast path: if both are fresh, exit silently and immediately.

DAYS=14
SECONDS_THRESHOLD=$((DAYS * 24 * 60 * 60))
NOW=$(date +%s)
STAMP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/brew-check"
STAMP_UPDATE="$STAMP_DIR/last_update"
STAMP_UPGRADE="$STAMP_DIR/last_upgrade"

# Read a timestamp file (0 if missing).
read_stamp() {
    local stamp
    [[ -f "$1" ]] && read -r stamp < "$1" && echo "$stamp" || echo 0
}

LAST_UPDATE=$(read_stamp "$STAMP_UPDATE")
LAST_UPGRADE=$(read_stamp "$STAMP_UPGRADE")
UPDATE_AGE=$((NOW - LAST_UPDATE))
UPGRADE_AGE=$((NOW - LAST_UPGRADE))

# Fast path: both fresh → say nothing, do nothing.
if [[ $UPDATE_AGE -le $SECONDS_THRESHOLD && $UPGRADE_AGE -le $SECONDS_THRESHOLD ]]; then
    exit 0
fi

# Slow path: something is overdue, so it's worth talking.
[[ -d "$STAMP_DIR" ]] || mkdir -p "$STAMP_DIR"

echo "Checking Homebrew maintenance status..."
echo ""

if [[ $UPDATE_AGE -gt $SECONDS_THRESHOLD ]]; then
    echo "[!] brew update was last run $((UPDATE_AGE / 86400)) days ago (threshold: $DAYS days)"
else
    echo "[ok] brew update was run $((UPDATE_AGE / 86400)) days ago"
fi

if [[ $UPGRADE_AGE -gt $SECONDS_THRESHOLD ]]; then
    echo "[!] brew upgrade was last run ~$((UPGRADE_AGE / 86400)) days ago (threshold: $DAYS days)"
else
    echo "[ok] brew upgrade was run ~$((UPGRADE_AGE / 86400)) days ago"
fi

echo ""

read -rp "Would you like to run brew update && brew upgrade now? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo ""
        echo "Running brew update..."
        if brew update; then
            echo "$NOW" > "$STAMP_UPDATE"
        fi
        echo ""
        echo "Running brew upgrade..."
        if brew upgrade; then
            echo "$NOW" > "$STAMP_UPGRADE"
        fi
        echo ""
        echo "Done! Homebrew is up to date."
        ;;
    *)
        echo "Skipped. Remember to update soon!"
        ;;
esac
