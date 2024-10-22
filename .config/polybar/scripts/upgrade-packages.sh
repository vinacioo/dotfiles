#!/bin/sh

# Perform the system upgrade with pacman
echo "Upgrading Official and AUR Packages..."
paru -Syyu --noconfirm

# After the upgrade, refresh the Polybar module
~/.config/polybar/scripts/update-packages.sh # Re-run the update check
polybar-msg cmd restart                      # Restart Polybar to refresh the module
