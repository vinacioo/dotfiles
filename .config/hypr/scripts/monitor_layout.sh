#!/bin/bash
# Hyprland Monitor Layout Manager
# This script allows manual configuration of monitor layouts
# Usage: ./monitor_layout.sh [left|right|only-edp|auto] [keyboard-layout]

ACTION="$1"
KB_LAYOUT="$2"

# Log file for debugging
LOG_FILE="/tmp/monitor_layout.log"
echo "===== Monitor layout change started at $(date) =====" >>"$LOG_FILE"
echo "Action: $ACTION, Keyboard Layout: $KB_LAYOUT" >>"$LOG_FILE"

# Get monitor information
get_monitors() {
  # Get connected monitors information
  local edp_connected=$(hyprctl monitors -j | jq '.[] | select(.name | contains("eDP")) | .name' -r)
  local hdmi_a1_connected=$(hyprctl monitors -j | jq '.[] | select(.name == "HDMI-A-1") | .name' -r)
  local hdmi1_connected=$(hyprctl monitors -j | jq '.[] | select(.name == "HDMI-1") | .name' -r)

  # Determine HDMI monitor name if any connected
  local hdmi_name=""
  local hdmi_desc=""

  if [[ -n "$hdmi_a1_connected" ]]; then
    hdmi_name="HDMI-A-1"
    hdmi_desc=$(hyprctl monitors -j | jq '.[] | select(.name == "HDMI-A-1") | .description' -r)
  elif [[ -n "$hdmi1_connected" ]]; then
    hdmi_name="HDMI-1"
    hdmi_desc=$(hyprctl monitors -j | jq '.[] | select(.name == "HDMI-1") | .description' -r)
  fi

  # Fallback for eDP name if not detected
  local edp_name=${edp_connected:-eDP-1}

  # Get main keyboard for layout switching
  local keyboard=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .name')

  # Log detected monitors and keyboard
  echo "Detected monitors: eDP: $edp_name, HDMI: $hdmi_name ($hdmi_desc)" >>"$LOG_FILE"
  echo "Main keyboard: $keyboard" >>"$LOG_FILE"

  # Export monitor and keyboard info to be used in functions
  export HDMI_NAME="$hdmi_name"
  export HDMI_DESC="$hdmi_desc"
  export EDP_NAME="$edp_name"
  export KEYBOARD="$keyboard"
}

# Clean up previous workspace and monitor configurations
clean_previous_config() {
  # Clear workspace assignments
  for i in {1..10}; do
    hyprctl keyword workspace "$i,monitor:"
  done
  echo "Cleared previous workspace assignments" >>"$LOG_FILE"

  # Clear windowrules
  hyprctl keyword --remove-all 'windowrulev2'
  echo "Cleared previous windowrules" >>"$LOG_FILE"

  # Kill any existing waybar instances
  if pgrep waybar >/dev/null; then
    killall waybar
    echo "Killed existing waybar instances" >>"$LOG_FILE"
  fi
}

# Function to handle app launching with better timing
launch_app() {
  local app="$1"
  local workspace="$2"
  local class="$3"

  # Create windowrule for the app
  hyprctl keyword windowrulev2 "workspace $workspace silent,class:^($class)$"

  # Focus the workspace
  hyprctl dispatch workspace "$workspace"

  # Small delay before launching
  sleep 1

  # Launch the app if not already running
  if ! pgrep -f "$app" >/dev/null; then
    nohup "$app" >/dev/null 2>&1 &
    echo "Launching $app on workspace $workspace" >>"$LOG_FILE"
  else
    echo "$app already running" >>"$LOG_FILE"
  fi
}

# Set up dual monitor with LG on the left
setup_lg_left() {
  echo "Setting up LG monitor on the left" >>"$LOG_FILE"

  # Configure monitor positions
  hyprctl keyword monitor "HDMI-A-1,preferred,0x0,1.0"
  hyprctl keyword monitor "eDP-1,preferred,1920x0,1.0"

  # Assign workspaces to monitors
  for i in {1..5}; do
    hyprctl keyword workspace "$i,monitor:$HDMI_NAME"
    hyprctl dispatch moveworkspacetomonitor "$i" "$HDMI_NAME"
  done

  for i in {6..10}; do
    hyprctl keyword workspace "$i,monitor:$EDP_NAME"
    hyprctl dispatch moveworkspacetomonitor "$i" "$EDP_NAME"
  done

  # Focus monitors and workspaces
  sleep 1
  hyprctl dispatch focusmonitor "$HDMI_NAME"
  hyprctl dispatch workspace 1

  hyprctl dispatch focusmonitor "$EDP_NAME"
  hyprctl dispatch workspace 6

  # Set US keyboard layout using the manager script
  if [[ -z "$KB_LAYOUT" ]]; then
    ~/.config/hypr/scripts/kb_layout_manager.sh us
    echo "Set keyboard layout to US using kb_layout_manager.sh" >>"$LOG_FILE"
  fi

  # Start waybar with appropriate config
  waybar -c ~/.config/waybar/config-left.jsonc -s ~/.config/waybar/style.css &

  # Launch applications
  sleep 2
  launch_app "librewolf" 1 "LibreWolf"
  launch_app "betterbird" 10 "eu.betterbird.Betterbird"

  notify-send "Monitor Setup" "$HDMI_NAME (LG) on LEFT — Workspaces 1-5 on HDMI, 6-10 on eDP" -t 5000
}

# Set up dual monitor with Dell on the right
setup_dell_right() {
  echo "Setting up Dell monitor on the right" >>"$LOG_FILE"

  # Configure monitor positions
  hyprctl keyword monitor "eDP-1,preferred,0x0,1.0"
  hyprctl keyword monitor "HDMI-A-1,preferred,1366x0,1.0"

  # Assign workspaces to monitors
  for i in {1..5}; do
    hyprctl keyword workspace "$i,monitor:$EDP_NAME"
    hyprctl dispatch moveworkspacetomonitor "$i" "$EDP_NAME"
  done

  for i in {6..10}; do
    hyprctl keyword workspace "$i,monitor:$HDMI_NAME"
    hyprctl dispatch moveworkspacetomonitor "$i" "$HDMI_NAME"
  done

  # Focus monitors and workspaces
  sleep 1
  hyprctl dispatch focusmonitor "$EDP_NAME"
  hyprctl dispatch workspace 1

  hyprctl dispatch focusmonitor "$HDMI_NAME"
  hyprctl dispatch workspace 6

  # Set BR keyboard layout using the manager script
  if [[ -z "$KB_LAYOUT" ]]; then
    ~/.config/hypr/scripts/kb_layout_manager.sh br
    echo "Set keyboard layout to BR using kb_layout_manager.sh" >>"$LOG_FILE"
  fi

  # Start waybar with appropriate config
  waybar -c ~/.config/waybar/config-right.jsonc -s ~/.config/waybar/style.css &

  # Launch applications
  sleep 2
  launch_app "librewolf" 1 "LibreWolf"
  launch_app "betterbird" 10 "eu.betterbird.Betterbird"

  notify-send "Monitor Setup" "HDMI on RIGHT — Workspaces 1-5 on eDP, 6-10 on HDMI" -t 5000
}

# Set up single monitor (only eDP)
setup_single_monitor() {
  echo "Setting up single monitor ($EDP_NAME)" >>"$LOG_FILE"

  # Configure monitor
  hyprctl keyword monitor "eDP-1,preferred,0x0,1.0"
  hyprctl keyword monitor "HDMI-1,disable"
  hyprctl keyword monitor "HDMI-A-1,disable"

  # Assign workspaces to monitor
  for i in {1..10}; do
    hyprctl keyword workspace "$i,monitor:$EDP_NAME"
    hyprctl dispatch moveworkspacetomonitor "$i" "$EDP_NAME"
  done

  # Focus monitor and workspace
  sleep 1
  hyprctl dispatch focusmonitor "$EDP_NAME"
  hyprctl dispatch workspace 1

  # Set BR keyboard layout using the manager script
  if [[ -z "$KB_LAYOUT" ]]; then
    ~/.config/hypr/scripts/kb_layout_manager.sh br
    echo "Set keyboard layout to BR using kb_layout_manager.sh" >>"$LOG_FILE"
  fi

  # Start waybar for single monitor
  waybar -c ~/.config/waybar/config-single.jsonc -s ~/.config/waybar/style.css &

  # Launch applications
  sleep 2
  launch_app "librewolf" 1 "LibreWolf"
  launch_app "betterbird" 10 "eu.betterbird.Betterbird"

  notify-send "Monitor Setup" "Single Monitor — All workspaces on $EDP_NAME" -t 5000
}

# Apply system rules
apply_system_rules() {
  # Add your desired windowrules here
  hyprctl keyword windowrulev2 "float,class:scratchpad-pkg"
  hyprctl keyword windowrulev2 "size 500 632,class:scratchpad-pkg"
  hyprctl keyword windowrulev2 "float,title:^(Calendar Reminders)$"
  hyprctl keyword windowrulev2 "size 500 500,title:^(Calendar Reminders)$"

  # Ignore maximize requests from apps
  hyprctl keyword windowrulev2 "suppressevent maximize, class:.*"

  echo "Applied system windowrules" >>"$LOG_FILE"
}

# Main execution
main() {
  # Get monitor information
  get_monitors

  # Clean up previous configuration
  clean_previous_config

  # Choose the appropriate setup based on action
  case "$ACTION" in
  left)
    if [[ "$HDMI_DESC" == *"LG Electronics 23MP55"* ]]; then
      setup_lg_left
    else
      setup_dell_right
      notify-send "Monitor Layout" "Not an LG monitor, using right layout instead" -t 5000
    fi
    ;;
  right)
    setup_monitor_right
    ;;
  only-edp)
    setup_single_monitor
    ;;
  auto)
    if [[ "$HDMI_DESC" == *"LG Electronics 23MP55"* ]]; then
      setup_lg_left
    elif [[ "$HDMI_DESC" == *"Dell Inc. DELL P2722H"* ]]; then
      setup_dell_right
    elif [[ -n "$HDMI_NAME" ]]; then
      setup_generic_right
    else
      setup_single_monitor
    fi
    ;;
  *)
    notify-send "Monitor Layout" "Unknown layout: $ACTION. Use 'left', 'right', 'only-edp', or 'auto'" -t 5000
    exit 1
    ;;
  esac

  # Apply common system rules
  apply_system_rules

  # Check for keyboard layout parameter - override setup layouts if specified
  if [[ -n "$KB_LAYOUT" ]]; then
    ~/.config/hypr/scripts/kb_layout_manager.sh "$KB_LAYOUT"
    echo "Keyboard layout parameter '$KB_LAYOUT' overrode default setup layout" >>"$LOG_FILE"
  fi

  # Make sure waybar gets layout update signal
  pkill -RTMIN+1 waybar

  echo "===== Monitor layout change completed at $(date) =====" >>"$LOG_FILE"
}

# Set up dual monitor with generic HDMI on the right
setup_generic_right() {
  echo "Setting up generic HDMI monitor on the right" >>"$LOG_FILE"

  # Configure monitor positions
  hyprctl keyword monitor "eDP-1,preferred,0x0,1.0"
  hyprctl keyword monitor "$HDMI_NAME,preferred,1920x0,1.0"

  # Assign workspaces to monitors
  for i in {1..5}; do
    hyprctl keyword workspace "$i,monitor:eDP-1"
    hyprctl dispatch moveworkspacetomonitor "$i" "eDP-1"
  done

  for i in {6..10}; do
    hyprctl keyword workspace "$i,monitor:$HDMI_NAME"
    hyprctl dispatch moveworkspacetomonitor "$i" "$HDMI_NAME"
  done

  # Focus monitors and workspaces
  sleep 1
  hyprctl dispatch focusmonitor "eDP-1"
  hyprctl dispatch workspace 1

  hyprctl dispatch focusmonitor "$HDMI_NAME"
  hyprctl dispatch workspace 6

  # Set BR keyboard layout using the manager script
  if [[ -z "$KB_LAYOUT" ]]; then
    ~/.config/hypr/scripts/kb_layout_manager.sh br
    echo "Set keyboard layout to BR using kb_layout_manager.sh" >>"$LOG_FILE"
  fi

  # Start waybar with appropriate config
  waybar -c ~/.config/waybar/config-right.jsonc -s ~/.config/waybar/style.css &

  # Launch applications
  sleep 2
  launch_app "librewolf" 1 "LibreWolf"
  launch_app "betterbird" 10 "eu.betterbird.Betterbird"

  notify-send "Monitor Setup" "HDMI on RIGHT — Workspaces 1-5 on eDP, 6-10 on HDMI" -t 5000
}

# Run the main function
main
