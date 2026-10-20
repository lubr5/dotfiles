#!/bin/bash
# Bluetooth off / nothing connected -> crossed-out symbol; connected -> symbol + device name(s)
on=$(printf '\U000f00af')    # bluetooth
off=$(printf '\U000f00b2')   # bluetooth, crossed out

powered=$(bluetoothctl show 2>/dev/null | awk '/Powered:/ {print $2}')
if [ "$powered" != "yes" ]; then
  echo "$off"
  exit 0
fi

names=$(bluetoothctl devices Connected 2>/dev/null | cut -d' ' -f3- | paste -sd',' - | sed 's/,/, /g')
if [ -z "$names" ]; then
  echo "$off"
else
  echo "$on $names"
fi
