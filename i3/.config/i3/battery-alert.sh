#!/bin/sh
# Pops up a warning once when the battery reaches THRESHOLD% while discharging.
# It re-arms when you plug in or the charge rises above the threshold.
THRESHOLD=${THRESHOLD:-10}
BAT=/sys/class/power_supply/BAT0   # same battery as your polybar config
alerted=0

while true; do
  cap=$(cat "$BAT/capacity")
  status=$(cat "$BAT/status")
  if [ "$status" = "Discharging" ] && [ "$cap" -le "$THRESHOLD" ]; then
    if [ "$alerted" -eq 0 ]; then
      dunstify -a battery -u critical -t 0 \
        -h string:x-dunst-stack-tag:battery \
        "Battery low: ${cap}%" "Plug in your charger."
      alerted=1
    fi
  else
    alerted=0
  fi
  sleep 30
done
