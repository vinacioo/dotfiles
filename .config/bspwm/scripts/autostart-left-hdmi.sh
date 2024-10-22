# handling dual monitor
if xrandr -q | grep 'HDMI-1 connected'; then
  xrandr --output HDMI-1 --left-of eDP-1 --auto
  bspc monitor eDP-1 -d VI VII VIII IX X
  bspc monitor HDMI-1 -d I II III IV V
else
  bspc monitor eDP-1 -d I II III IV V VI VII VIII IX X
fi
xrandr --output eDP-1 --primary

# set wallpaper
wallpaper="/home/vinacio/.config/bspwm/wallpapers/gray.png"
feh --bg-fill "$wallpaper"
