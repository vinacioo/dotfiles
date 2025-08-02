#!/bin/bash

layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

case "$layout" in
*"Portuguese (Brazil"*) echo "󰌓 br" ;;
*"English (US"*) echo "󰌓 us" ;;
*) echo "$layout" ;;
esac
