#!/bin/sh

charge=$(acpi | sed -r -n 's/.*([0-9][0-9])%.*/\1/p');
out=$(echo "Battery at $charge%")
state=$(acpi | sed -r -n 's/Battery 0: (\w+), .*/\1/p')

if [ "$state" = "Discharging" ]
then
	if [ $charge -le 25 ]
	then
		/usr/bin/notify-send "$out"
		if [ $charge -le 10 ]
		then
			sleep 2
			/usr/bin/notify-send "Will prompt for hibernation."
			sleep 2
			/home/jp/bin/prompt.sh "Hibernate?" "systemctl hibernate"
		fi
	fi
fi
