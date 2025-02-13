#!/usr/bin/env bash

POLYBAR_HIDDEN="/tmp/polybarhidden"
PADDING=28 # Adjust this to match your Polybar height

if [ -f "$POLYBAR_HIDDEN" ]; then
  polybar-msg cmd show
  bspc config top_padding "$PADDING" # Restore top padding
  rm "$POLYBAR_HIDDEN"
else
  polybar-msg cmd hide
  bspc config top_padding 0 # Remove padding when Polybar is hidden
  touch "$POLYBAR_HIDDEN"
fi
