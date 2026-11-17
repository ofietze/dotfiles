#!/usr/bin/env zsh
# Single-pass refresh of all workspace items: visibility, display, app icons, focus highlight.

CONFIG_DIR="$HOME/.config/sketchybar"
ICON_MAP_SOURCED=1 source "$CONFIG_DIR/plugins/icon_map_fn.sh"
source "$CONFIG_DIR/plugins/ws_colors.sh"

typeset -A DISPLAY_MAP WS_DISPLAY STRIP

# aerospace monitor id -> sketchybar display
while IFS=: read -r a s; do DISPLAY_MAP[$a]=$s; done < <("$CONFIG_DIR/plugins/display_map.sh")

# workspace -> sketchybar display
while IFS='|' read -r ws mon; do
  WS_DISPLAY[$ws]="${DISPLAY_MAP[$mon]:-1}"
done < <(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}')

# workspace -> icon strip
while IFS='|' read -r ws app; do
  [[ -z "$app" ]] && continue
  icon_map "$app"
  STRIP[$ws]+=" $icon_result"
done < <(aerospace list-windows --all --format '%{workspace}|%{app-name}')

focused=$(aerospace list-workspaces --focused)

args=()
for sid in {1..10}; do
  if [[ -n "${STRIP[$sid]}" || "$sid" == "$focused" ]]; then
    args+=(--set space.$sid drawing=on label="${STRIP[$sid]:+ ${STRIP[$sid]}}")
    [[ -n "${WS_DISPLAY[$sid]}" ]] && args+=(display="${WS_DISPLAY[$sid]}")
    if [[ "$sid" == "$focused" ]]; then
      args+=(background.color=0xff5e81ac background.border_color=0xff81a1c1)
    else
      args+=(background.color=0xff3c3c3c background.border_color="${WS_BORDER[$sid]}")
    fi
  else
    args+=(--set space.$sid drawing=off)
  fi
done

sketchybar "${args[@]}"
