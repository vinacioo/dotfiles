#!/bin/bash

ALL_MONITORS=$(hyprctl monitors)
HDMI_LEFT_MODEL="HDMI-A-1"
HDMI_RIGHT_MODEL="HDMI-1"
HDMI_CONNECTED=""
EDP_NAME=$(echo "$ALL_MONITORS" | grep "Name:" | grep eDP | awk '{print $2}')

# Determine which HDMI is connected
if echo "$ALL_MONITORS" | grep -q "$HDMI_LEFT_MODEL"; then
  HDMI_CONNECTED="left"
elif echo "$ALL_MONITORS" | grep -q "$HDMI_RIGHT_MODEL"; then
  HDMI_CONNECTED="right"
else
  HDMI_CONNECTED="none"
fi

# Kill any already running instances (optional)
pkill -x librewolf
pkill -x betterbird
sleep 1

# === Launch apps based on layout ===

if [ "$HDMI_CONNECTED" = "left" ]; then
  # HDMI-A-1 is on the left
  hyprctl dispatch exec "[workspace 1 silent] librewolf"
  sleep 1
  hyprctl dispatch exec "[workspace 10 silent] betterbird"

  notify-send "Launch Apps" "HDMI-A-1 (left): librewolf on 1, betterbird on 10"

elif [ "$HDMI_CONNECTED" = "right" ]; then
  # HDMI-1 is on the right
  hyprctl dispatch exec "[workspace 10 silent] librewolf"
  sleep 1
  hyprctl dispatch exec "[workspace 1 silent] betterbird"

  notify-send "Launch Apps" "HDMI-1 (right): librewolf on 10, betterbird on 1"

else
  # No HDMI, only eDP
  hyprctl dispatch exec "[workspace 1 silent] librewolf"
  sleep 1
  hyprctl dispatch exec "[workspace 10 silent] betterbird"

  notify-send "Launch Apps" "Only eDP: librewolf on 1, betterbird on 10"
fi
