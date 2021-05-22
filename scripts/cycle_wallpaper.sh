#!/bin/sh

if [ "$#" -ne 0 ]; then
	USED_WP_DIR="$1"
else
	USED_WP_DIR="/home/jp/Pictures/Wallpapers/Low_Poly/"
fi

WP_PATH="$USED_WP_DIR/*"

MIN_MOD_10=$(( $(date +"%-M") / 10 ))

I=0

set_wp() {
	HORSEMAN=$2
	convert -scale 1920x1080 $1 /tmp/wallpaper.png
	composite -gravity center /home/jp/Pictures/$HORSEMAN.png /tmp/wallpaper.png /tmp/wallpaper.png
	# /home/jp/Documents/Code/arch-pape-maker/mepapemaker.sh /tmp/wallpaper.png /tmp/wallpaper.png

	# convert -spread 15 /tmp/wallpaper.png /tmp/lockscreen.png

	# $HOME/Documents/Code/corrupter/corrupter \
	# 	-bheight 10 \
	# 	-boffset 5	\
	# 	-lag 0.0005 \
	# 	-lb 7 \
	# 	-lg 0 \
	# 	-lr -7 \
	# 	-mag 0.5 \
	# 	-meanabber 2 \
	# 	-stdabber 10 \
	# 	-stdoffset 5 \
	# 	-stride 0.05 \
	# 	/tmp/wallpaper.png /tmp/lockscreen.png
	feh --bg-fill /tmp/wallpaper.png
}

for wp in $WP_PATH;
do
	if [ $MIN_MOD_10 -eq $I ]
	then
		set_wp $wp $(hostname)
		return
	else
		I=$(( I + 1))
	fi
done

