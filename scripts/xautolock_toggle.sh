#!/bin/sh

res=$(echo "Enable
Disable" | dmenu -i -p "xautolock:")

if [ $res = "Enable" ]; then
	xautolock -enable
fi

if [ $res = "Disable" ]; then
	xautolock -disable
fi

