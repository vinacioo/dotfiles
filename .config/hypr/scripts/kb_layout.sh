#!/bin/bash
# Script to show the current keyboard layout in waybar
# Save as ~/.config/waybar/scripts/kb_layout.sh and make executable

# Always use active_keymap in this case
layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

# Normalize output using pattern matching
case "$layout" in
*"English (US"*)
  echo "󰌌 US"
  ;;
*"Portuguese (Brazil"*)
  echo "󰌌 BR"
  ;;
*)
  echo "󰌌 $(echo "$layout" | awk '{print toupper(substr($0,1,2))}')"
  ;;
esac
