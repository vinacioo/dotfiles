#!/bin/bash

# Get the connection status of HDMI-1
HDMI_STATUS=$(xrandr | grep "HDMI-1 connected")

if [ -n "$HDMI_STATUS" ]; then
  # HDMI-1 is connected, toggle it on
  xrandr --output HDMI-1 --auto --left-of eDP-1
  notify-send "HDMI" "Turned on."
else
  # HDMI-1 is disconnected, turn it off
  xrandr --output HDMI-1 --off
  notify-send "HDMI" "Turned off."
fi

# bash /home/vinacio/.config/scripts/autostart.sh
