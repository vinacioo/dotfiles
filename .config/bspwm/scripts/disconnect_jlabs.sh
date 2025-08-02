#!/bin/bash
export PATH=$PATH:/usr/bin

# Set MAC Address of JLab JBuds Air Icon
DEVICE_MAC="00:00:E0:00:11:9C"

# Notify about disconnection attempt
notify-send "🔵 Bluetooth" "Disconnecting from JBuds Air Icon..."

# Disconnect using bluetoothctl
bluetoothctl <<EOF
disconnect $DEVICE_MAC
remove $DEVICE_MAC
EOF

# Check if the device is disconnected
if ! bluetoothctl info $DEVICE_MAC | grep -q "Connected: yes"; then
  notify-send "✅ Bluetooth" "Disconnected from JBuds Air Icon!"
else
  notify-send "❌ Bluetooth" "Failed to disconnect from JBuds Air Icon!"
fi
