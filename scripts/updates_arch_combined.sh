#!/bin/sh

if ! updates_arch=$(checkupdates 2> /dev/null | tee /tmp/updates_total | wc -l ); then
	updates_arch=0
fi

if ! updates_aur=$(paru -Qum 2> /dev/null | tee -a /tmp/updates_total | wc -l); then
# if ! updates_aur=$(cower -u 2> /dev/null | wc -l); then
# if ! updates_aur=$(trizen -Su --aur --quiet | wc -l); then
	updates_aur=0
fi

updates=$(($updates_arch + $updates_aur))

if [ "$updates" -gt 0 ]; then
	cat /tmp/updates_total
else
	echo -n "" > /tmp/updates_total
fi
