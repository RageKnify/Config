#! /bin/sh

DATE=$(date +"%Y-%m-%d_%H:%M:%S")
FILE_NAME="/tmp/screenshot_${DATE}.png"


scrot $FILE_NAME
exec gimp $FILE_NAME
