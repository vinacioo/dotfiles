#!/bin/sh

window_id=$1
window_class=$2
window_instance=$3
window_title="$(xwininfo -id "$window_id" | sed -nE 's/^xwininfo.{1,}"(.*)"$/\1/p')"

# Default consequences
consequences=""

# Rule for Zotero message box "Remove from Collection"
if [ "$window_class" = "Zotero" ]; then
  if [ "$window_title" = "Remove from Collection" ]; then
    consequences="state=floating center=on"
    # Set sticky explicitly using bspc
    bspc node "$window_id" --flag sticky
  fi
fi

# Output consequences
echo "$consequences"
