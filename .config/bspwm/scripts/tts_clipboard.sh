#!/bin/bash

# Get the text from the clipboard
CLIPBOARD_TEXT=$(xclip -out -selection clipboard)

# Check if the clipboard is empty
if [[ -z "$CLIPBOARD_TEXT" ]]; then
  echo "Error: Clipboard is empty."
  exit 1
fi

# Convert the clipboard text to speech using gtts-cli and play it with mpv
echo "$CLIPBOARD_TEXT" | tr "\n" " " | gtts-cli -l en - | mpv --force-window=no --really-quiet -
