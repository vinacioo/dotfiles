#!/bin/bash

# Get the current keyboard layout
CURRENT_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')

# Toggle between the BR and US layouts and send a notification
if [ "$CURRENT_LAYOUT" == "br" ]; then
  setxkbmap -model abnt -layout us -variant intl
  notify-send "Keyboard Layout" "Switched to EN layout"
else
  setxkbmap -model abnt2 -layout br -variant abnt2
  notify-send "Keyboard Layout" "Switched to BR layout"
fi
