#!/bin/bash
# Keyboard layout manager script
# Usage: ./kb_layout_manager.sh [us|br|toggle|next|get]

# Get the main keyboard
KEYBOARD=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .name')
CURRENT_LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

# Function to get the current layout index
get_layout_index() {
  case "$CURRENT_LAYOUT" in
  *"English (US"*) echo "0" ;;
  *"Portuguese (Brazil"*) echo "1" ;;
  *) echo "-1" ;; # Unknown
  esac
}

# Function to get the current layout code
get_layout_code() {
  case "$CURRENT_LAYOUT" in
  *"English (US"*) echo "us" ;;
  *"Portuguese (Brazil"*) echo "br" ;;
  *) echo "$CURRENT_LAYOUT" ;; # Unknown
  esac
}

# Main function
if [[ -z "$KEYBOARD" ]]; then
  echo "No main keyboard detected" >&2
  exit 1
fi

# Process command
case "$1" in
"us")
  # Set layout to US
  hyprctl switchxkblayout "$KEYBOARD" 0
  echo "Keyboard layout set to US"
  ;;
"br")
  # Set layout to BR
  hyprctl switchxkblayout "$KEYBOARD" 1
  echo "Keyboard layout set to BR"
  ;;
"toggle")
  # Toggle between layouts
  CURRENT_INDEX=$(get_layout_index)
  if [[ "$CURRENT_INDEX" == "0" ]]; then
    hyprctl switchxkblayout "$KEYBOARD" 1
    echo "Keyboard layout toggled to BR"
  else
    hyprctl switchxkblayout "$KEYBOARD" 0
    echo "Keyboard layout toggled to US"
  fi
  ;;
"next")
  # Use Hyprland's next functionality
  hyprctl switchxkblayout "$KEYBOARD" next
  echo "Keyboard layout switched to next"
  ;;
"get")
  # Get the current layout code
  get_layout_code
  ;;
"get-index")
  # Get the current layout index
  get_layout_index
  ;;
*)
  echo "Usage: $0 [us|br|toggle|next|get|get-index]"
  echo "  us: Set to US layout"
  echo "  br: Set to BR layout"
  echo "  toggle: Toggle between US and BR"
  echo "  next: Switch to next layout"
  echo "  get: Get current layout code (us/br)"
  echo "  get-index: Get current layout index (0/1)"
  exit 1
  ;;
esac

# Signal waybar to update the layout indicator
pkill -RTMIN+1 waybar
