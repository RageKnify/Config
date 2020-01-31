#! /bin/sh

test -f /tmp/sc.png && rm /tmp/sc.png


scrot /tmp/sc.png
exec gimp /tmp/sc.png
