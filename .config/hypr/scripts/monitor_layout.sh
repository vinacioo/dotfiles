#!/bin/bash
ACTION="$1"

# Get monitor information
ALL_MONITORS=$(hyprctl monitors -j)
HDMI_A1_CONNECTED=$(echo "$ALL_MONITORS" | jq '.[] | select(.name == "HDMI-A-1") | .name' -r)
HDMI1_CONNECTED=$(echo "$ALL_MONITORS" | jq '.[] | select(.name == "HDMI-1") | .name' -r)
EDP_NAME=$(echo "$ALL_MONITORS" | jq '.[] | select(.name | contains("eDP")) | .name' -r)

# Determine which HDMI port is connected
HDMI_NAME=""
HDMI_DESC=""
if [[ -n "$HDMI_A1_CONNECTED" ]]; then
  HDMI_NAME="HDMI-A-1"
  HDMI_DESC=$(echo "$ALL_MONITORS" | jq '.[] | select(.name == "HDMI-A-1") | .description' -r)
elif [[ -n "$HDMI1_CONNECTED" ]]; then
  HDMI_NAME="HDMI-1"
  HDMI_DESC=$(echo "$ALL_MONITORS" | jq '.[] | select(.name == "HDMI-1") | .description' -r)
fi

# Fallback defaults
EDP_NAME=${EDP_NAME:-eDP-1}
EDP_WIDTH=1920

# Log the detected monitors for debugging
echo "=========================" >>/tmp/monitor_layout.log
date >>/tmp/monitor_layout.log
echo "Action: $ACTION" >>/tmp/monitor_layout.log
echo "HDMI Name: $HDMI_NAME" >>/tmp/monitor_layout.log
echo "HDMI Description: $HDMI_DESC" >>/tmp/monitor_layout.log
echo "eDP Name: $EDP_NAME" >>/tmp/monitor_layout.log

# Function to assign workspaces for LG monitor on the left
assign_static_workspaces() {
  local hdmi="$1"
  local edp="$2"
  # HDMI: 1–5
  for ws in {1..5}; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$hdmi"
    hyprctl keyword workspace "$ws, monitor:$hdmi"
  done
  # eDP: 6–10
  for ws in {6..10}; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$edp"
    hyprctl keyword workspace "$ws, monitor:$edp"
  done
  # Focus HDMI on workspace 1
  hyprctl dispatch focusmonitor "$hdmi"
  hyprctl dispatch workspace 1
  # Focus eDP on workspace 10
  hyprctl dispatch focusmonitor "$edp"
  hyprctl dispatch workspace 10
}

# Function to assign workspaces for non-LG monitor on the right
assign_static_workspaces_non_lg() {
  local edp="$1"
  local hdmi="$2"
  # eDP: 1–5
  for ws in {1..5}; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$edp"
    hyprctl keyword workspace "$ws, monitor:$edp"
  done
  # HDMI: 6–10
  for ws in {6..10}; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$hdmi"
    hyprctl keyword workspace "$ws, monitor:$hdmi"
  done
  hyprctl dispatch focusmonitor "$edp"
  hyprctl dispatch workspace 1
  hyprctl dispatch focusmonitor "$hdmi"
  hyprctl dispatch workspace 10
}

# Function to assign all workspaces to single monitor
assign_static_workspaces_single() {
  local edp="$1"
  for ws in {1..10}; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$edp"
    hyprctl keyword workspace "$ws, monitor:$edp"
  done
  hyprctl dispatch focusmonitor "$edp"
  hyprctl dispatch workspace 1
}

# Get main keyboard for layout switching
KEYBOARD=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .name')

# Clear any previous windowrules that might interfere
hyprctl keyword --remove-all 'windowrulev2'

# Set application rules for workspaces
hyprctl keyword windowrulev2 "workspace 1 silent,class:^(LibreWolf)$"
hyprctl keyword windowrulev2 "workspace 10 silent,class:^(eu.betterbird.Betterbird)$"

case "$ACTION" in
left)
  # For the LG monitor on the left
  if [[ "$HDMI_DESC" == *"LG Electronics 23MP55"* ]]; then
    hyprctl keyword monitor "$HDMI_NAME, preferred, 0x0, 1.0"
    hyprctl keyword monitor "$EDP_NAME, preferred, ${EDP_WIDTH}x0, 1.0"
    assign_static_workspaces "$HDMI_NAME" "$EDP_NAME"
    notify-send "Monitor Layout" "LG HDMI on the left of eDP"
    # Set keyboard layout to US
    hyprctl switchxkblayout "$KEYBOARD" 0
  else
    notify-send "Monitor Layout" "Not an LG monitor, using right layout instead"
    # Call right action instead since this is not an LG monitor
    hyprctl keyword monitor "$EDP_NAME, preferred, 0x0, 1.0"
    hyprctl keyword monitor "$HDMI_NAME, preferred, ${EDP_WIDTH}x0, 1.0"
    assign_static_workspaces_non_lg "$EDP_NAME" "$HDMI_NAME"
    notify-send "Monitor Layout" "HDMI on the right of eDP"
    # Set keyboard layout to BR
    hyprctl switchxkblayout "$KEYBOARD" 1
  fi
  ;;
right)
  # For any other monitor (including Dell) on the right
  hyprctl keyword monitor "$EDP_NAME, preferred, 0x0, 1.0"
  hyprctl keyword monitor "$HDMI_NAME, preferred, ${EDP_WIDTH}x0, 1.0"
  assign_static_workspaces_non_lg "$EDP_NAME" "$HDMI_NAME"
  notify-send "Monitor Layout" "HDMI on the right of eDP"
  # Set keyboard layout to BR
  hyprctl switchxkblayout "$KEYBOARD" 1
  ;;
only-edp)
  # Single monitor setup
  hyprctl keyword monitor "$EDP_NAME, preferred, 0x0, 1.0"
  hyprctl keyword monitor "HDMI-A-1, disable"
  hyprctl keyword monitor "HDMI-1, disable"
  assign_static_workspaces_single "$EDP_NAME"
  notify-send "Monitor Layout" "Only eDP enabled"
  # Set keyboard layout to BR
  hyprctl switchxkblayout "$KEYBOARD" 1
  ;;
auto)
  # Auto-detect based on monitor description
  if [[ "$HDMI_DESC" == *"LG Electronics 23MP55"* ]]; then
    # LG monitor should be on the left
    hyprctl keyword monitor "$HDMI_NAME, preferred, 0x0, 1.0"
    hyprctl keyword monitor "$EDP_NAME, preferred, ${EDP_WIDTH}x0, 1.0"
    assign_static_workspaces "$HDMI_NAME" "$EDP_NAME"
    notify-send "Monitor Layout" "Auto: LG HDMI on the left of eDP"
    # Set keyboard layout to US
    hyprctl switchxkblayout "$KEYBOARD" 0
  elif [[ -n "$HDMI_NAME" ]]; then
    # Any other HDMI monitor (including Dell) should be on the right
    hyprctl keyword monitor "$EDP_NAME, preferred, 0x0, 1.0"
    hyprctl keyword monitor "$HDMI_NAME, preferred, ${EDP_WIDTH}x0, 1.0"
    assign_static_workspaces_non_lg "$EDP_NAME" "$HDMI_NAME"
    notify-send "Monitor Layout" "Auto: HDMI on the right of eDP"
    # Set keyboard layout to BR
    hyprctl switchxkblayout "$KEYBOARD" 1
  else
    # No external monitor detected
    hyprctl keyword monitor "$EDP_NAME, preferred, 0x0, 1.0"
    hyprctl keyword monitor "HDMI-A-1, disable"
    hyprctl keyword monitor "HDMI-1, disable"
    assign_static_workspaces_single "$EDP_NAME"
    notify-send "Monitor Layout" "Auto: Only eDP enabled"
    # Set keyboard layout to BR
    hyprctl switchxkblayout "$KEYBOARD" 1
  fi
  ;;
*)
  notify-send "Monitor Layout" "Unknown layout: $ACTION. Use 'left', 'right', 'only-edp', or 'auto'"
  ;;
esac

# Restart waybar
pkill waybar &>/dev/null
sleep 0.5
waybar &>/dev/null &

# Launch key applications if not already running
if ! pgrep -f "librewolf" >/dev/null; then
  nohup librewolf >/dev/null 2>&1 &
fi

if ! pgrep -f "betterbird" >/dev/null; then
  nohup betterbird >/dev/null 2>&1 &
fi

echo "Layout applied: $ACTION" >>/tmp/monitor_layout.log
