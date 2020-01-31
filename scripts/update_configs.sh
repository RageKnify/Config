#!/bin/sh

cat /home/jp/.config/polybar/base /home/jp/.config/polybar/$(hostname) > /home/jp/.config/polybar/config
cat /home/jp/.config/sxhkd/base /home/jp/.config/sxhkd/$(hostname) > /home/jp/.config/sxhkd/sxhkdrc
cat /home/jp/.config/i3/colors /home/jp/.config/i3/base /home/jp/.config/i3/$(hostname) > /home/jp/.config/i3/config
i3-msg reload
