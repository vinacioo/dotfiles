#!/bin/bash
# Script to toggle or set brightness for both HDMI and eDP monitors
# Usage: ./brightness.sh [brightness_level]

# Get current eDP brightness as percentage
get_edp_brightness() {
  current=$(brightnessctl get 2>/dev/null || echo 0)
  max=$(brightnessctl max 2>/dev/null || echo 100)
  echo $(((current * 100 + max / 2) / max))
}

# Find the correct I2C bus for the HDMI monitor
find_hdmi_bus() {
  # Look through the output of ddcutil detect to find an active display
  # Use grep to find lines that contain 'I2C bus' and then extract the bus number
  ddcutil detect 2>/dev/null | grep -B 2 "HDMI" | grep "I2C bus" | grep -o "/dev/i2c-[0-9]*" | head -1
}

# Set eDP brightness
set_edp_brightness() {
  local level=$1
  brightnessctl set "$level%" 2>/dev/null
  echo "eDP brightness set to $level%"
}

# Set HDMI brightness
set_hdmi_brightness() {
  local level=$1
  local hdmi_bus=$(find_hdmi_bus)

  if [ -z "$hdmi_bus" ]; then
    echo "HDMI monitor not detected, skipping brightness adjustment"
    return 1
  fi

  echo "Using HDMI monitor on bus $hdmi_bus"

  # Extract just the bus number (e.g., 5 from /dev/i2c-5)
  bus_number=$(echo "$hdmi_bus" | grep -o "[0-9]*$")

  if ddcutil setvcp 10 $level --bus=$bus_number 2>/dev/null; then
    echo "HDMI brightness set to $level% on bus $bus_number"
    return 0
  else
    echo "Failed to set HDMI brightness"
    return 1
  fi
}

# Set specific brightness level for monitors
set_brightness() {
  local level=$1

  # Always set eDP brightness
  set_edp_brightness $level

  # Try to set HDMI brightness
  set_hdmi_brightness $level
}

# Main script logic
if [ $# -eq 1 ]; then
  # If an argument is provided, set to that specific level
  set_brightness $1
else
  # Toggle between 10% and 100%
  edp_brightness=$(get_edp_brightness)
  if [ $edp_brightness -lt 50 ]; then
    set_brightness 100
  else
    set_brightness 10
  fi
fi
