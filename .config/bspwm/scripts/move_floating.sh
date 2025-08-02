#!/bin/sh
case "$1" in
up) bspc node -v 0 -10 ;;
down) bspc node -v 0 10 ;;
left) bspc node -v -10 0 ;;
right) bspc node -v 10 0 ;;
esac
