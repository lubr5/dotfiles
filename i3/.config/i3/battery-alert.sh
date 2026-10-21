#!/bin/sh
# Pops up a warning once when the battery reaches THRESHOLD% while discharging.
# The popup closes itself when the charger is plugged in; it re-arms for the next time.
THRESHOLD=${THRESHOLD:-10}
BAT=/sys/class/power_supply/BAT0
alerted=0
id=

while true; do
  cap=$(cat "$BAT/capacity")
  status=$(cat "$BAT/status")
  if [ "$status" = "Discharging" ] && [ "$cap" -le "$THRESHOLD" ]; then
    if [ "$alerted" -eq 0 ]; then
      id=$(dunstify -p -a battery -u critical -t 0 \
        -h string:x-dunst-stack-tag:battery \
        "Battery low: ${cap}%" "Plug in your charger.")
      alerted=1
    fi
  else
    if [ "$alerted" -eq 1 ]; then
      dunstify -C "$id"      # close the popup now the charger is in
      alerted=0
    fi
  fi
  sleep 5
done
