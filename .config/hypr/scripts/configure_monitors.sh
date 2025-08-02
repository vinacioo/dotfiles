#!/bin/bash
# Clean, unified Hyprland monitor layout manager

# Get action parameter (left, right, only-edp, auto)
ACTION="${1:-auto}" # Default to "auto" if nothing passed

# Always try to enable HDMI manually if plugged
hyprctl keyword monitor HDMI-A-1,preferred,auto,1
sleep 1

# Detect connected monitors
eDP=$(hyprctl monitors -j | jq -r '.[] | select(.name=="eDP-1") | .name')
HDMI=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("HDMI")) | .name')
HDMI_DESC=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("HDMI")) | .description')

# Kill Waybar if running
killall waybar 2>/dev/null
sleep 1

# Helper: Move a block of workspaces to a monitor
move_workspaces() {
  local start=$1
  local end=$2
  local monitor=$3
  for i in $(seq $start $end); do
    hyprctl dispatch moveworkspacetomonitor "$i" "$monitor"
  done
}

# Helper: Launch app if not already running
launch_once() {
  local app=$1
  local workspace=$2
  if ! pgrep -x "$app" >/dev/null; then
    hyprctl dispatch exec "[workspace $workspace silent] $app"
  fi
}

# --- Monitor Layouts ---

setup_only_edp() {
  hyprctl reload
  hyprctl keyword monitor "$eDP,preferred,0x0,1"
  hyprctl keyword monitor "HDMI-1,disable"
  hyprctl keyword monitor "HDMI-A-1,disable"

  for i in {1..10}; do
    hyprctl keyword workspace "$i,monitor:$eDP"
  done
  hyprctl keyword workspace "1,monitor:$eDP,default:true"
  hyprctl keyword workspace "10,monitor:$eDP,default:true"

  move_workspaces 1 10 "$eDP"

  hyprctl dispatch focusmonitor "$eDP"
  hyprctl dispatch workspace 1

  launch_once librewolf 1
  launch_once thunderbird 10

  waybar -c ~/.config/waybar/config-single.jsonc -s ~/.config/waybar/style.css &
}

setup_hdmi_left() {

  hyprctl reload
  hyprctl keyword monitor "$HDMI,preferred,0x0,1"
  hyprctl keyword monitor "$eDP,preferred,1920x0,1"

  for i in {1..5}; do
    hyprctl keyword workspace "$i,monitor:$HDMI"
  done
  for i in {6..10}; do
    hyprctl keyword workspace "$i,monitor:$eDP"
  done
  hyprctl keyword workspace "1,monitor:$HDMI,default:true"
  hyprctl keyword workspace "10,monitor:$eDP,default:true"

  move_workspaces 1 5 "$HDMI"
  move_workspaces 6 10 "$eDP"

  # Make Thunderbird (workspace 10) visible on eDP
  hyprctl dispatch focusmonitor "$eDP"
  hyprctl dispatch workspace 10
  # Then move back focus to LibreWolf (workspace 1) on HDMI
  hyprctl dispatch focusmonitor "$HDMI"
  hyprctl dispatch workspace 1

  launch_once librewolf 1
  launch_once thunderbird 10

  waybar -c ~/.config/waybar/config-left.jsonc -s ~/.config/waybar/style.css &
}

setup_hdmi_right() {
  hyprctl reload
  hyprctl keyword monitor "$eDP,preferred,0x0,1"
  hyprctl keyword monitor "$HDMI,preferred,1366x0,1"

  for i in {1..5}; do
    hyprctl keyword workspace "$i,monitor:$eDP"
  done
  for i in {6..10}; do
    hyprctl keyword workspace "$i,monitor:$HDMI"
  done
  hyprctl keyword workspace "1,monitor:$eDP,default:true"
  hyprctl keyword workspace "10,monitor:$HDMI,default:true"

  move_workspaces 1 5 "$eDP"
  move_workspaces 6 10 "$HDMI"

  # Make Thunderbird (workspace 1) visible on eDP
  hyprctl dispatch focusmonitor "$eDP"
  hyprctl dispatch workspace 1
  # Then move back focus to LibreWolf (workspace 10) on HDMI
  hyprctl dispatch focusmonitor "$HDMI"
  hyprctl dispatch workspace 10

  launch_once thunderbird 1
  launch_once librewolf 10

  waybar -c ~/.config/waybar/config-right.jsonc -s ~/.config/waybar/style.css &
}

# --- Main Execution ---

case "$ACTION" in
only-edp)
  setup_only_edp
  ;;
left)
  setup_hdmi_left
  ;;
right)
  setup_hdmi_right
  ;;
auto)
  if [[ -n "$HDMI" ]]; then
    if [[ "$HDMI_DESC" == *"LG Electronics 23MP55"* ]]; then
      setup_hdmi_left
    else
      setup_hdmi_right
    fi
  else
    setup_only_edp
  fi
  ;;
*)
  echo "Invalid action: $ACTION"
  exit 1
  ;;
esac

# Refresh Waybar
sleep 1
pkill -RTMIN+1 waybar
