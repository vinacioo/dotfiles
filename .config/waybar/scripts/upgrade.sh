#!/usr/bin/env bash

# Sway + Waybar Package Update Scratchpad Script
# This script manages a scratchpad terminal for package updates using Alacritty and tmux.
# It uses swaymsg to search for and manage the scratchpad window.

# Search for a window with the class 'scratchpad-pkg'
winclass=$(swaymsg -t get_tree | jq -r '.. | select(.app_id? == "scratchpad-pkg") | .id' | head -n1)

if [ -z "$winclass" ]; then
  # Launch alacritty with the specified class and run tmux to execute the upgrade
  alacritty --class scratchpad-pkg --config-file ~/.config/alacritty/alacritty-updates.toml \
    -e tmux new-session -A -s Updating-Packages "$HOME/.config/waybar/scripts/upgrade_packages.sh"
else
  if [ ! -f /tmp/scratchpad-pkg ]; then
    # Create a file to indicate the window is hidden and move to scratchpad
    touch /tmp/scratchpad-pkg && swaymsg "[con_id=$winclass] move scratchpad"
  elif [ -f /tmp/scratchpad-pkg ]; then
    # Remove the file to indicate the window is shown and show from scratchpad
    rm /tmp/scratchpad-pkg && swaymsg "[con_id=$winclass] scratchpad show"
  fi
fi
