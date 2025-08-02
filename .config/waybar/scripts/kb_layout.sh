#!/bin/bash

# Detect which compositor is running
if pgrep -x "Hyprland" >/dev/null; then
  # Hyprland method
  layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')
elif pgrep -x "sway" >/dev/null; then
  # Sway method
  layout=$(swaymsg -t get_inputs | jq -r '.[] | select(.type == "keyboard") | .xkb_active_layout_name' | head -1)
else
  # Fallback - try to detect from environment or use a default
  echo "󰌓 ??"
  exit 1
fi

# Parse the layout and display appropriate icon/text
case "$layout" in
*"Portuguese (Brazil"* | *"Portuguese"* | *"Brazil"*) echo "󰌓 br" ;;
*"English (US"* | *"English"* | *"US"*) echo "󰌓 us" ;;
*) echo "󰌓 ${layout:0:2}" ;; # Show first 2 characters as fallback
esac
