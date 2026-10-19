#!/bin/sh
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1 | tr -d '%')
case "$1" in
  up)
    if [ "$vol" -ge 100 ]; then
      pactl set-sink-volume @DEFAULT_SINK@ 100%
    else
      pactl set-sink-volume @DEFAULT_SINK@ +1%
    fi
    ;;
  down)
    pactl set-sink-volume @DEFAULT_SINK@ -1%
    ;;
esac
