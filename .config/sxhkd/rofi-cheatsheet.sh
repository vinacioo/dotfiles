#!/usr/bin/env bash

# This script manages a scratchpad terminal using Alacritty,
# toggling its visibility and showing the sxhkdrc cheatsheet.
# It opens a floating Alacritty terminal with `fzf` for interactive selection
# of keybindings and descriptions, using a custom Alacritty config file.

# The class name for the scratchpad terminal
winclass="sxhkdrc-scratchpad"

# Define the custom Alacritty config file path
alacritty_config="$HOME/.config/alacritty/alacritty-sxhkdrc.toml"

# Check if a window with the class 'sxhkdrc-scratchpad' exists
winclass_id="$(xdotool search --class "$winclass")"

if [ -z "$winclass_id" ]; then
  # If no such window exists, open a new Alacritty terminal in floating mode and run the cheatsheet
  alacritty --class "$winclass" --config-file "$alacritty_config" -e bash -c "
    cat ~/.config/sxhkd/sxhkdrc | \
    awk '/^[a-z]/ && last {print \$0,\"\t\",last} {last=\"\"} /^#/{last=\$0}' | \
    column -t -s \$'\t' | fzf
  "
else
  # If the window exists, toggle its visibility
  if [ ! -f /tmp/sxhkdrc-scratchpad ]; then
    # If the file doesn't exist, create it and hide the terminal window
    touch /tmp/sxhkdrc-scratchpad && xdotool windowunmap "$winclass_id"
  else
    # If the file exists, remove it and show the terminal window
    rm /tmp/sxhkdrc-scratchpad && xdotool windowmap "$winclass_id"
  fi
fi
