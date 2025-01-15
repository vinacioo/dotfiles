#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

polybar-msg cmd quit >/dev/null 2>&1

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# polybar-msg cmd quit

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    if [[ "$m" == "HDMI-1" ]]; then
      MONITOR=$m polybar --reload custom-HDMI &
    elif [[ "$m" == "eDP-1" ]]; then
      MONITOR=$m polybar --reload custom-eDP &
    fi
  done
else
  polybar --reload custom-eDP & # Default fallback
fi

echo "Bars launched..."
