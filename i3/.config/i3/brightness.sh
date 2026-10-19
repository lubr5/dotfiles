#!/bin/sh
echo "$(date +%T) called: $1" >> /tmp/brightness.log
exec 2>>/tmp/brightness.log
# usage: brightness.sh up|down
case "$1" in
  up)   brightnessctl -q set +5% ;;
  down) brightnessctl -q -n set 5%- ;;   # -n stops it dropping to a black screen
esac

pct=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
dunstify -a brightness -u low -t 1500 \
  -h string:x-dunst-stack-tag:brightness \
  -h int:value:"$pct" "Brightness: ${pct}%"
