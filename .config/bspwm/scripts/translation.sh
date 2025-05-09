#!/usr/bin/env bash

## Define colors
original_text_color="#625E5A"
translation_color="#E6C384"

# Fetch the translation JSON from Google Translate API (using the new API endpoint)
translation_json=$(wget -U "Mozilla/5.0" -qO - "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=pt-br&dt=t&q=$(xsel -o | sed "s/[\"'<>]//g" | jq -sRr @uri)")

# Extract all parts of the translated text using jq and concatenate them into a single string
translation=$(echo $translation_json | jq -r '.[0][][0]' | tr '\n' ' ' | sed 's/ \+/ /g' | sed 's/ \. /\./g' | sed 's/ \. /\./g' | sed 's/ $//g')

# Display the original text using notify-send
notify-send --icon=info "Original Text" "<span foreground='$original_text_color'>$(xsel -o)</span>"

# Display the translation in a single notification using notify-send
notify-send --icon=info "Translation" "<span foreground='$translation_color'>$translation</span>"
