#!/bin/bash

# Copy the selected text from the primary selection to the clipboard
xclip -out -selection primary | xclip -in -selection clipboard

# Convert the clipboard text to speech using gtts-cli and play it
xsel --clipboard | tr "\n" " " | gtts-cli -l en - | mpv -

##!/bin/bash
#
## Get the selected text from the primary selection
#INPUT=$(xclip -out -selection primary)
#
## Check if input is empty
#if [[ -z "$INPUT" ]]; then
#  echo "Error: No text selected."
#  exit 1
#fi
#
## Default language (you can override this with the LANGUAGE variable)
#LANGUAGE=${LANGUAGE:-"en-us"}
#
## Split input into chunks if needed (Google TTS has a 100-character limit per request)
#STRINGNUM=0
#ary=($INPUT)
#for key in "${!ary[@]}"; do
#  SHORTTMP[$STRINGNUM]="${SHORTTMP[$STRINGNUM]} ${ary[$key]}"
#  LENGTH=$(echo -n "${SHORTTMP[$STRINGNUM]}" | wc -c)
#  if [[ "$LENGTH" -lt "100" ]]; then
#    SHORT[$STRINGNUM]="${SHORTTMP[$STRINGNUM]}"
#  else
#    STRINGNUM=$((STRINGNUM + 1))
#    SHORTTMP[$STRINGNUM]="${ary[$key]}"
#    SHORT[$STRINGNUM]="${ary[$key]}"
#  fi
#done
#
## Process each chunk and play the audio using mpv
#for key in "${!SHORT[@]}"; do
#  # Encode the text for URL compatibility
#  NEXTURL=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''${SHORT[$key]}'''))")
#
#  # Send the text to Google TTS and play the audio
#  mpv --force-window=no --really-quiet "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$NEXTURL&tl=$LANGUAGE"
#done
