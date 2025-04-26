#!/bin/bash
# Simple and robust Hyprland monitor configuration script with side positioning

LOG_FILE="/tmp/hyprland_setup.log"
POSITION="$1"

echo "===== Monitor configuration ($POSITION) started at $(date) =====" >>"$LOG_FILE"

# Clear existing configurations
hyprctl keyword monitor "eDP-1,preferred,0x0,1.0"
hyprctl keyword monitor "HDMI-A-1,disable"
hyprctl keyword monitor "HDMI-1,disable"

# Assign all workspaces initially to eDP-1
for i in {1..10}; do
  hyprctl keyword workspace "$i,monitor:eDP-1"
done

# Detect HDMI monitors
data=$(hyprctl monitors -j)
hdmi_monitor=$(echo "$data" | jq -r '.[] | select(.name | startswith("HDMI")) | .name')

if [[ -n "$hdmi_monitor" ]]; then
  echo "HDMI monitor detected: $hdmi_monitor" >>"$LOG_FILE"

  if [[ "$POSITION" == "left" ]]; then
    # HDMI on the left
    hyprctl keyword monitor "$hdmi_monitor,preferred,0x0,1.0"
    hyprctl keyword monitor "eDP-1,preferred,auto,1.0"
  else
    # HDMI on the right
    hyprctl keyword monitor "eDP-1,preferred,0x0,1.0"
    hyprctl keyword monitor "$hdmi_monitor,preferred,auto,1.0"
  fi

  # Assign workspaces dynamically based on position
  if [[ "$POSITION" == "left" ]]; then
    for i in {1..5}; do
      hyprctl keyword workspace "$i,monitor:$hdmi_monitor"
    done
    for i in {6..10}; do
      hyprctl keyword workspace "$i,monitor:eDP-1"
    done
  else
    for i in {1..5}; do
      hyprctl keyword workspace "$i,monitor:eDP-1"
    done
    for i in {6..10}; do
      hyprctl keyword workspace "$i,monitor:$hdmi_monitor"
    done
  fi

  # Set initial focus
  hyprctl dispatch focusmonitor "$hdmi_monitor"
  hyprctl dispatch workspace 1

  hyprctl dispatch focusmonitor eDP-1
  hyprctl dispatch workspace 6

  # Notification
  notify-send "Monitor Setup" "HDMI on $POSITION — Workspaces configured accordingly" -t 4000

  # Restart Waybar with appropriate config
  if pgrep waybar >/dev/null; then
    pkill waybar
    sleep 1
  fi

  if [[ "$POSITION" == "left" ]]; then
    waybar -c ~/.config/waybar/config-left.jsonc -s ~/.config/waybar/style.css &
  else
    waybar -c ~/.config/waybar/config-right.jsonc -s ~/.config/waybar/style.css &
  fi
else
  echo "No HDMI monitor detected, single monitor setup" >>"$LOG_FILE"

  # Single monitor focus
  hyprctl dispatch focusmonitor eDP-1
  hyprctl dispatch workspace 1

  # Notification
  notify-send "Monitor Setup" "Single monitor mode — All workspaces on eDP-1" -t 4000

  # Restart Waybar with single monitor config
  if pgrep waybar >/dev/null; then
    pkill waybar
    sleep 1
  fi
  waybar -c ~/.config/waybar/config-single.jsonc -s ~/.config/waybar/style.css &
fi

# Final log
echo "===== Monitor configuration completed at $(date) =====" >>"$LOG_FILE"
