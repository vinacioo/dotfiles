#!/bin/bash

ICON_PACMAN="󰮯"
ICON_AUR="󰏔"
NO_UPDATES_ICON="󰣇"

RED="#e46876"
BLUE="#7fb4ca"
GRAY="#606060"

# Get update counts
pacman_updates=$(checkupdates 2>/dev/null | wc -l || echo 0)
aur_updates=$(paru -Qua 2>/dev/null | wc -l || echo 0)

# plus icon
plus_icon="<span color='$GRAY'>+</span>"

if [ "$pacman_updates" -gt 0 ] || [ "$aur_updates" -gt 0 ]; then
  # Color pacman count
  if [ "$pacman_updates" -gt 0 ]; then
    pacman_display="<span color='$RED'>$ICON_PACMAN $pacman_updates</span>"
  else
    pacman_display="<span color='$BLUE'>$ICON_PACMAN $pacman_updates</span>"
  fi

  # Color AUR count
  if [ "$aur_updates" -gt 0 ]; then
    aur_display="<span color='$RED'>$ICON_AUR $aur_updates</span>"
  else
    aur_display="<span color='$BLUE'>$ICON_AUR $aur_updates</span>"
  fi

  echo "$pacman_display $plus_icon $aur_display"
else
  echo "<span color='$BLUE'>$NO_UPDATES_ICON</span>"
fi
