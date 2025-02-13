#!/bin/bash

# Copy the selected text from the primary selection to the clipboard
xclip -out -selection primary | xclip -in -selection clipboard

# Convert the clipboard text to speech using gtts-cli and play it
xsel --clipboard | tr "\n" " " | gtts-cli -l en - | mpv -
