# Border gradient per workspace (1..10). Sourced by sketchybarrc and update_workspace_icons.sh.
gradient_colors=(0xAA73daca 0xAA7aa2f7 0xAAbb9af7)
typeset -A WS_BORDER
for i in {0..9}; do
  WS_BORDER[$((i + 1))]=${gradient_colors[$(( i * (${#gradient_colors} - 1) / 9 + 1 ))]}
done
