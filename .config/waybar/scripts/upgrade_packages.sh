#!/bin/sh

# Waybar Package Upgrade Execution Script
# Performs the system upgrade with paru and refreshes Waybar

echo "Upgrading Official and AUR Packages..."

# Perform the system upgrade with paru
paru -Syyu --noconfirm

# Check if upgrade was successful
if [ $? -eq 0 ]; then
  echo "Package upgrade completed successfully!"
else
  echo "Package upgrade encountered errors. Exit code: $?"
fi

echo "Refreshing update information..."

# After the upgrade, refresh the Waybar module
~/.config/waybar/scripts/update_packages.sh # Re-run the update check

# Refresh Waybar - multiple methods depending on your setup
echo "Restarting Waybar to refresh modules..."

# Method 1: Send SIGUSR2 to reload Waybar config (preferred if supported)
if pgrep waybar >/dev/null; then
  pkill -SIGUSR2 waybar
  echo "Waybar config reloaded"
else
  echo "Waybar not running, starting it..."
  waybar &
fi

echo "Update process completed!"
echo "Press Enter to close this terminal..."
read -r
