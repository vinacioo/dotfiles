#!/bin/sh

# Icons for display
ICON_PACMAN="󰮯"
ICON_AUR=""
NO_UPDATES_ICON="󰣇"

# Polybar formatting for colors
RED="%{F#ff5555}"  # Red color for updates
BLUE="%{F#076678}" # Blue color for no updates
RESET="%{F-}"      # Reset color

# Check for official repository updates using checkupdates with refresh
if ! pacman_updates=$(checkupdates 2>/dev/null | wc -l); then
  pacman_updates=0
fi

# Check for AUR updates using paru with a more robust command
if ! aur_updates=$(paru -Qua 2>/dev/null | wc -l); then
  aur_updates=0
fi

# Display the result
if [ "$pacman_updates" -gt 0 ] || [ "$aur_updates" -gt 0 ]; then
  # If there are updates, show separate counts for pacman and AUR with individual colors
  pacman_display="${BLUE}$ICON_PACMAN $pacman_updates"
  aur_display="${RED}$ICON_AUR $aur_updates"

  # Show AUR updates in red if present, otherwise blue
  if [ "$aur_updates" -gt 0 ]; then
    aur_display="${RED}$ICON_AUR  $aur_updates"
  else
    aur_display="${BLUE}$ICON_AUR  $aur_updates"
  fi

  # Show pacman updates in red if present, otherwise blue
  if [ "$pacman_updates" -gt 0 ]; then
    pacman_display="${RED}$ICON_PACMAN $pacman_updates"
  else
    pacman_display="${BLUE}$ICON_PACMAN $pacman_updates"
  fi

  echo "$pacman_display ${RESET}+ $aur_display $RESET"
else
  # If there are no updates, show a simple blue icon
  echo "${BLUE}$NO_UPDATES_ICON${RESET}"
fi
