#!/bin/bash
# This cmd can send polybar to just above bspwm which will not have fullscreen problem. Oh ya remember to install xdo first.
xwininfo -name bspwm -wm | grep "Window id" | cut -d" " -f4 | xargs -I {} xdo above -N Polybar -t {}
