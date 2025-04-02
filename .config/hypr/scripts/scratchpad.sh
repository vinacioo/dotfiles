#!/usr/bin/env bash

windows_in() {
  hyprctl clients -j | jq ".[] | select(.workspace.name == \"special:$1\" )"
}

toggle_scratchpad() {
  workspace_name="$1"
  cmd="$2"

  windows=$(windows_in "$workspace_name")
  if [ -z "$windows" ]; then
    hyprctl dispatch exec "[workspace special:$workspace_name silent] $cmd"
    sleep 0.2
  fi
  hyprctl dispatch togglespecialworkspace "$workspace_name"
}

case "$1" in
terminal)
  toggle_scratchpad "terminal" "ghostty --class=com.markmandel.scratchpad -e tmux new-session -A -s scratchpad"
  ;;
*)
  echo "Unknown scratchpad type: $1"
  ;;
esac
