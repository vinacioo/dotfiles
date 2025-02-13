#!/bin/bash

# Primary monitor (laptop screen)
PRIMARY_MONITOR="eDP-1"

# Function to set up HDMI monitor on the right side of the primary monitor
setup_hdmi() {
  # Get the HDMI monitor name (usually starts with HDMI)
  HDMI_MONITOR=$(xrandr --query | grep -w "connected" | grep -i "HDMI" | awk '{print $1}')

  if [ -z "$HDMI_MONITOR" ]; then
    echo "No HDMI monitor detected."
  else
    echo "HDMI monitor detected: $HDMI_MONITOR"
    # Position the HDMI monitor to the right of the primary monitor
    xrandr --output $HDMI_MONITOR --auto --right-of $PRIMARY_MONITOR
    echo "HDMI monitor positioned to the right of $PRIMARY_MONITOR."
  fi
}

# Monitor for HDMI connection changes
while true; do
  # Wait for a change in the display status
  inotifywait -e modify /sys/class/drm/*/status

  # Call the setup function
  setup_hdmi
done
