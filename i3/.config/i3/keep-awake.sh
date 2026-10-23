#!/bin/sh
# Don't let the screen lock or blank while a browser is playing audio (e.g. YouTube).
while true; do
  if pactl list sink-inputs 2>/dev/null | awk -v RS= '/Corked: no/ && tolower($0) ~ /application.name = "(firefox|librewolf)/ {f=1} END {exit !f}'; then
    xset s reset
  fi
  sleep 30
done
