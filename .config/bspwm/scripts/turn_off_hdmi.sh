#!/bin/bash
my_laptop_external_monitor=$(xrandr --query | grep 'HDMI')
if [[ $my_laptop_external_monitor = *connected* ]]; then
	xrandr --output HDMI-1 --off
fi
