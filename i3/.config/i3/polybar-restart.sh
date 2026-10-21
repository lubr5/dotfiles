#!/bin/sh
# Restart polybar so that exactly one copy is running.
exec 8>/tmp/polybar-restart.lock
flock 8                       # wait here if another restart is in progress
pkill -x polybar
i=0
while pgrep -x polybar > /dev/null && [ "$i" -lt 30 ]; do sleep 0.1; i=$((i+1)); done
setsid -f polybar main -c ~/.config/polybar/config.ini 8>&- 9>&- > /tmp/polybar.log 2>&1
sleep 2
pgrep -x polybar | head -n -1 | xargs -r kill   # keep only the newest
