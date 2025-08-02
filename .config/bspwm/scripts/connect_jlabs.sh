#!/bin/bash
export PATH=$PATH:/usr/bin

# Set MAC Address of JLab JBuds Air Icon
DEVICE_MAC="00:00:E0:00:11:9C"

# Notify starting connection
notify-send "🔵 Bluetooth" "Connecting to JBuds Air Icon..."

# Connect using bluetoothctl
bluetoothctl <<EOF
power on
agent on
trust $DEVICE_MAC
connect $DEVICE_MAC
EOF

# Check if the connection was successful
if bluetoothctl info $DEVICE_MAC | grep -q "Connected: yes"; then
  notify-send "✅ Bluetooth" "Connected to JBuds Air Icon!"
else
  notify-send "❌ Bluetooth" "Failed to connect to JBuds Air Icon!"
fi
