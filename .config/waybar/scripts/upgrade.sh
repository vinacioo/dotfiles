#!/usr/bin/env bash

# Create a special scratchpad workspace for package updates
WORKSPACE="special:magic"

# Check if the window exists in the special workspace
if hyprctl clients | grep -q "class: scratchpad-pkg"; then
  # If the window exists, toggle its visibility by toggling the special workspace
  hyprctl dispatch togglespecialworkspace magic
else
  # If the window doesn't exist, create it in the special workspace
  hyprctl dispatch exec "alacritty --class scratchpad-pkg --config-file ~/.config/alacritty/alacritty-updates.toml -e tmux new-session -A -s Updating-Packages '$HOME/.config/polybar/scripts/upgrade-packages.sh'"

  # Small delay to ensure the window is created
  sleep 0.1

  # Move it to the special workspace
  hyprctl dispatch movetoworkspacesilent "$WORKSPACE"

  # Show the special workspace
  hyprctl dispatch togglespecialworkspace magic
fi
