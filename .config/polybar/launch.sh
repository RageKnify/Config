#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u "$(id -ru)" -x polybar >/dev/null; do sleep 1; done

# Launch bar
. /home/jp/.colors
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload barBottom &
  done
else
  polybar --reload barBottom &
fi

echo "Bars launched..."
