#!/bin/sh

cat $HOME/.config/polybar/base $HOME/.config/polybar/$(hostname) > $HOME/.config/polybar/config
cat $HOME/.config/sxhkd/base $HOME/.config/sxhkd/$(hostname) > $HOME/.config/sxhkd/sxhkdrc
cat $HOME/.config/i3/colors $HOME/.config/i3/base $HOME/.config/i3/$(hostname) > $HOME/.config/i3/config
i3-msg reload
$HOME/.config/polybar/launch.sh
