#!/usr/bin/env bash

## Define colors
original_text_color="#625E5A"
translation_color="#E6C384"

# Function to check if window is XWayland
is_xwayland() {
  hyprctl activewindow -j | jq -r '.xwayland' | grep -q "true"
}

# Function to get active window class
get_window_class() {
  hyprctl activewindow -j | jq -r '.class'
}

# Get text based on whether we're in a Wayland or XWayland window
get_selection() {
  local window_class=$(get_window_class)
  local selected_text=""

  # If XWayland window (like Logseq)
  if is_xwayland; then
    # Try using xclip for X11 selection
    if command -v xclip >/dev/null; then
      # Try primary selection first (highlighted text)
      selected_text=$(xclip -o -selection primary 2>/dev/null)

      # If that fails, try clipboard selection
      if [ -z "$selected_text" ]; then
        selected_text=$(xclip -o -selection clipboard 2>/dev/null)
      fi

      # If both fail and it's Logseq, try forcing a copy
      if [ -z "$selected_text" ] && [[ "$window_class" == "Logseq" ]]; then
        # If ydotool is available, use it
        if command -v ydotool >/dev/null; then
          ydotool key ctrl+c
          sleep 0.5
          selected_text=$(xclip -o -selection clipboard 2>/dev/null)
        # Fallback to xdotool if available
        elif command -v xdotool >/dev/null; then
          xdotool key ctrl+c
          sleep 0.5
          selected_text=$(xclip -o -selection clipboard 2>/dev/null)
        fi
      fi
    fi
  # If native Wayland window
  else
    # Try primary selection first (highlighted text)
    selected_text=$(wl-paste -p 2>/dev/null)

    # If that fails, try clipboard
    if [ -z "$selected_text" ]; then
      selected_text=$(wl-paste 2>/dev/null)
    fi

    # If both fail, try forcing a copy
    if [ -z "$selected_text" ]; then
      if command -v ydotool >/dev/null; then
        ydotool key ctrl+c
        sleep 0.5
        selected_text=$(wl-paste 2>/dev/null)
      fi
    fi
  fi

  echo "$selected_text"
}

# Get the selected text
selected_text=$(get_selection)

# If no text is selected or clipboard is empty after all attempts, exit
if [ -z "$selected_text" ]; then
  notify-send --icon=error "Translation Error" "No text selected or unable to access selection"
  exit 1
fi

# URL encode the selected text for the API request
encoded_text=$(echo "$selected_text" | jq -sRr @uri)

# Fetch the translation JSON from Google Translate API
translation_json=$(wget -U "Mozilla/5.0" -qO - "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=pt-br&dt=t&q=$encoded_text")

# Extract all parts of the translated text using jq and concatenate them into a single string
translation=$(echo $translation_json | jq -r '.[0][][0]' | tr '\n' ' ' | sed 's/ \+/ /g' | sed 's/ \. /\./g' | sed 's/ \, /\,/g' | sed 's/ $//g')

# Display the original text using notify-send
notify-send --icon=info "Original Text" "<span foreground='$original_text_color'>$selected_text</span>"

# Display the translation in a single notification using notify-send
notify-send --icon=info "Translation" "<span foreground='$translation_color'>$translation</span>"
