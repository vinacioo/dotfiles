#!/bin/bash

BRIGHTNESS=$1
LOG="/tmp/hypridle_brightness.log"
echo "[$(date)] Triggered with brightness: $BRIGHTNESS" >>"$LOG"

# Set internal monitor (eDP)
if command -v brightnessctl &>/dev/null; then
  brightnessctl --device='intel_backlight' set "${BRIGHTNESS}%" >>"$LOG" 2>&1
elif command -v xrandr &>/dev/null; then
  xrandr --output eDP-1 --brightness $(awk "BEGIN {print $BRIGHTNESS/100}") >>"$LOG" 2>&1
fi

# Set external HDMI monitor (hardcoded bus 5)
(
  echo "[$(date)] Setting HDMI brightness on bus 5 to $BRIGHTNESS" >>"$LOG"
  ddcutil setvcp 10 "$BRIGHTNESS" --bus=5 >>"$LOG" 2>&1
) &
disown
