#!/bin/bash

# Check if wl-clipboard is installed
if ! command -v wl-paste &>/dev/null; then
  echo "Error: wl-clipboard is not installed. Please install it with your package manager."
  echo "For example: sudo pacman -S wl-clipboard (for Arch-based systems)"
  exit 1
fi

# Get text from Wayland primary selection (mouse selection)
SELECTED_TEXT=$(wl-paste -p 2>/dev/null)

# If primary selection is empty, try clipboard (Ctrl+C copy)
if [ -z "$SELECTED_TEXT" ]; then
  SELECTED_TEXT=$(wl-paste 2>/dev/null)
fi

# Check if any text was found
if [ -z "$SELECTED_TEXT" ]; then
  echo "Error: No text selected or copied. Please select text or copy it with Ctrl+C before running this script."
  exit 1
fi

# Show what text will be spoken
echo "Speaking: '$SELECTED_TEXT'"

# Convert selected text to speech and play it
echo "$SELECTED_TEXT" | tr "\n" " " | gtts-cli -l en - | mpv -
