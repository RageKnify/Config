#!/bin/sh

add_horseman() {
	IN=$1
	HORSEMAN=$2
	OUT=$3
	convert -scale 1920x1080 $IN $OUT
	composite -gravity center /home/jp/documents/pictures/$HORSEMAN.png $OUT $OUT
}

(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

if [ "$SOURCED" -eq 1 ]; then
	return
fi

if [ "$#" -lt 3 ]; then
	OUT=/tmp/horseman_wallpaper.png
else
	OUT="$3"
fi

if [ "$#" -lt 2 ]; then
	HORSEMAN="$(hostname)"
else
	HORSEMAN="$2"
fi

if [ "$#" -lt 1 ]; then
	echo "Must supply at least 1 argument, image on which to place horseman"
	echo "usage: $0 [HORSEMAN] [OUTPUT_FILE]"
	echo "HORSEMAN defaults to the machine's hostname"
	echo "OUTPUT_FILE defaults to /tmp/horseman_wallpaper.png"
	exit -1
else
	WALLPAPER="$1"
fi

add_horseman $WALLPAPER $HORSEMAN $OUT
