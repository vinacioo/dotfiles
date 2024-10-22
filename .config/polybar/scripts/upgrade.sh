#!/usr/bin/env bash

# This script manages a scratchpad terminal for package updates using Alacritty and tmux.
# It searches for a window with the class name 'scratchpad-pkg' to determine if the scratchpad terminal is already open.
# If the terminal is not open, it launches Alacritty with the class 'scratchpad-pkg' and runs tmux to execute the package upgrade commands.
# If the terminal is already open, the script toggles its visibility using a temporary file as a state indicator.

# Search for a window with the class 'scratchpad-pkg'
winclass="$(xdotool search --class scratchpad-pkg)"
if [ -z "$winclass" ]; then
  # Launch alacritty with the specified class and run tmux to execute the upgrade
  alacritty --class scratchpad-pkg --config-file ~/.config/alacritty/alacritty-updates.toml \
    -e tmux new-session -A -s Updating-Packages "$HOME/.config/polybar/scripts/upgrade-packages.sh"
else
  if [ ! -f /tmp/scratchpad-pkg ]; then
    # Create a file to indicate the window is hidden and unmap the window
    touch /tmp/scratchpad-pkg && xdotool windowunmap "$winclass"
  elif [ -f /tmp/scratchpad-pkg ]; then
    # Remove the file to indicate the window is shown and map the window back
    rm /tmp/scratchpad-pkg && xdotool windowmap "$winclass"
  fi
fi
