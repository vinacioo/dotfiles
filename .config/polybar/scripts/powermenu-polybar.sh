#!/usr/bin/env bash

if [ "$1" = "--normal" ]; then
    rofi -modi drun -show drun -theme drun
elif [ "$1" = "--power" ]; then
    result=$(cat $HOME/.config/rofi/powermenu | rofi -dmenu -i -theme power)

    case $result in
        logout)   bspc quit ;;
        lock)     dm-tool lock ;;
        reboot)   shutdown --reboot now ;;
        shutdown) shutdown --poweroff now ;;
    esac
fi

# #!/usr/bin/env bash
#
# ## Author  : Aditya Shakya
# ## Mail    : adi1090x@gmail.com
# ## Github  : @adi1090x
# ## Twitter : @adi1090x
#
# dir="~/.config/polybar/scripts"
# uptime=$(uptime -p | sed -e 's/up //g')
#
# rofi_command="rofi -theme $dir/powermenu.rasi"
#
# # Options
# shutdown=" Shutdown"
# reboot=" Restart"
# lock=" Lock"
# suspend=" Sleep"
# logout=" Logout"
#
# # Confirmation
# confirm_exit() {
# 	rofi -dmenu\
# 		-i\
# 		-no-fixed-num-lines\
# 		-p "Are You Sure? : "\
# 		-theme $dir/confirm.rasi
# }
# # Variable passed to rofi
# options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"
#
# chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
# case $chosen in
#     $shutdown)
# 	        systemctl poweroff
#         ;;
#     $reboot)
# 		systemctl reboot
#         ;;
#     $lock)
# 	        slock
#         ;;
#     $suspend)
# 		systemctl suspend
#         ;;
#     $logout)
# 		bspc quit
#         ;;
# esac
