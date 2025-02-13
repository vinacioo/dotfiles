#!/bin/bash

detect_hdmi_monitor() {
  # Step 1: Check if HDMI-1 is connected
  HDMI_INFO=$(xrandr --query | grep "HDMI-1 connected")
  if [[ -n "$HDMI_INFO" ]]; then
    echo "HDMI-1 is connected."

    # Step 2: Extract all monitor models from hwinfo
    MODELS=$(hwinfo --monitor | grep "Model:" | awk -F'"' '{print $2}')

    # Step 3: Check if the required model is in the list
    if echo "$MODELS" | grep -q "LG ELECTRONICS 23MP55"; then
      echo "Detected HDMI monitor: LG ELECTRONICS 23MP55. Applying hdmi-left profile..."
      autorandr -l hdmi-left
    else
      echo "Detected other HDMI monitor. Applying hdmi-right profile..."
      autorandr -l hdmi-right
    fi
  else
    echo "No HDMI monitor detected. Applying only-edp profile..."
    autorandr -l only-edp
  fi
}

# Call the function
detect_hdmi_monitor
