#!/bin/bash
# ~/.config/hypr/scripts/swap_windows.sh

echo "Debug: Starting window swap..."

# Get monitor info with both names and IDs
monitor1_name="eDP-1"
monitor2_name="HDMI-A-1"

# Get monitor IDs
monitor1_id=$(hyprctl monitors -j | jq -r --arg name "$monitor1_name" '.[] | select(.name==$name) | .id')
monitor2_id=$(hyprctl monitors -j | jq -r --arg name "$monitor2_name" '.[] | select(.name==$name) | .id')

echo "Monitor1: $monitor1_name (ID: $monitor1_id)"
echo "Monitor2: $monitor2_name (ID: $monitor2_id)"

# Get current active workspaces on each monitor
ws1=$(hyprctl monitors -j | jq -r --arg name "$monitor1_name" '.[] | select(.name==$name) | .activeWorkspace.id')
ws2=$(hyprctl monitors -j | jq -r --arg name "$monitor2_name" '.[] | select(.name==$name) | .activeWorkspace.id')

echo "Workspace on $monitor1_name: $ws1"
echo "Workspace on $monitor2_name: $ws2"

# Get all windows on each monitor's current workspace using monitor ID
windows1=$(hyprctl clients -j | jq -r --arg mid "$monitor1_id" --arg w "$ws1" '.[] | select(.monitor==($mid|tonumber) and .workspace.id==($w|tonumber)) | .address')
windows2=$(hyprctl clients -j | jq -r --arg mid "$monitor2_id" --arg w "$ws2" '.[] | select(.monitor==($mid|tonumber) and .workspace.id==($w|tonumber)) | .address')

echo "Windows on $monitor1_name (workspace $ws1): $windows1"
echo "Windows on $monitor2_name (workspace $ws2): $windows2"

# Count windows
count1=$(echo "$windows1" | grep -c '^0x' 2>/dev/null || echo "0")
count2=$(echo "$windows2" | grep -c '^0x' 2>/dev/null || echo "0")

echo "Found $count1 windows on $monitor1_name, $count2 windows on $monitor2_name"

if [ "$count1" -eq 0 ] && [ "$count2" -eq 0 ]; then
  echo "No windows found on the active workspaces of either monitor. Exiting."
  exit 1
fi

# Move windows from monitor1 to monitor2's workspace
if [ -n "$windows1" ] && [ "$count1" -gt 0 ]; then
  echo "Moving windows from $monitor1_name to $monitor2_name..."
  echo "$windows1" | while read -r addr; do
    if [[ -n "$addr" ]]; then
      echo "Moving window $addr to workspace $ws2"
      hyprctl dispatch movetoworkspacesilent $ws2,address:$addr
    fi
  done
fi

# Move windows from monitor2 to monitor1's workspace
if [ -n "$windows2" ] && [ "$count2" -gt 0 ]; then
  echo "Moving windows from $monitor2_name to $monitor1_name..."
  echo "$windows2" | while read -r addr; do
    if [[ -n "$addr" ]]; then
      echo "Moving window $addr to workspace $ws1"
      hyprctl dispatch movetoworkspacesilent $ws1,address:$addr
    fi
  done
fi

# Reload waybar to reload icons
killall -SIGUSR2 waybar

echo "Swap completed!"
