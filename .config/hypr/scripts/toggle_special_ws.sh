#!/bin/bash

# Script to toggle a special workspace in Hyprland
# Usage: ./toggle_special_ws.sh workspace_name "command to execute"

# Check if correct number of arguments provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 workspace_name [command]"
  echo "Example: $0 specialconfig \"alacritty --class specialconfig -e nvim ~/.config/hypr/hyprland.conf\""
  exit 1
fi

WORKSPACE_NAME="$1"
COMMAND="${2:-}"

# Check if Hyprland is running
if ! command -v hyprctl &>/dev/null; then
  echo "Error: hyprctl not found. Make sure Hyprland is running."
  exit 1
fi

# Get the active workspace
ACTIVE_WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.name' 2>/dev/null)

# Check if we're already in the special workspace
if [[ "$ACTIVE_WORKSPACE" == "special:$WORKSPACE_NAME" ]]; then
  # We're in the special workspace, toggle back to previous
  hyprctl dispatch togglespecialworkspace "$WORKSPACE_NAME"
else
  # Check if the special workspace already exists
  if hyprctl workspaces -j | jq -e ".[] | select(.name == \"special:$WORKSPACE_NAME\")" &>/dev/null; then
    # Special workspace exists, toggle to it
    hyprctl dispatch togglespecialworkspace "$WORKSPACE_NAME"
  else
    # Special workspace doesn't exist, create it and run command
    if [ -n "$COMMAND" ]; then
      # Toggle to create the workspace
      hyprctl dispatch togglespecialworkspace "$WORKSPACE_NAME"

      # Execute the command
      eval "$COMMAND" &
    else
      # Just toggle the workspace if no command specified
      hyprctl dispatch togglespecialworkspace "$WORKSPACE_NAME"
    fi
  fi
fi
