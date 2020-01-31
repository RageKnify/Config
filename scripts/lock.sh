#!/bin/bash

. /home/jp/.colors

i3lock -n -i /tmp/lockscreen.png \
    --insidecolor=$BASE0Ca --ringcolor=$BASE00a --line-uses-inside \
    --keyhlcolor=$BASE0Da --bshlcolor=$BASE08a --separatorcolor=000000ff \
    --insidevercolor=$BASE0Da --insidewrongcolor=$BASE08a \
    --ringvercolor=$BASE01a --ringwrongcolor=$BASE00a \
	--indpos="w/2:h-3*r" \
    --radius=30 --veriftext="" --wrongtext="" --noinputtext=""
