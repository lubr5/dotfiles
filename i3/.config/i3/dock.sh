#!/bin/sh
# Lid closed + external monitor -> external only; otherwise laptop screen + external.
# usage: dock.sh          apply once
#        dock.sh watch    re-apply when the lid/monitors change, and restart polybar if it dies

state() {
  echo "$(cat /proc/acpi/button/lid/*/state 2>/dev/null) $(xrandr --query | grep ' connected' | awk '{print $1}')"
}

restart_polybar() {
  setsid -f ~/.config/i3/polybar-restart.sh 9>&- > /dev/null 2>&1
}

apply() {
  internal=$(xrandr --query | awk '/^(eDP|LVDS)/ {print $1; exit}')
  externals=$(xrandr --query | awk '/ connected/ && $1 !~ /^(eDP|LVDS)/ {print $1}')
  lid=$(cat /proc/acpi/button/lid/*/state 2>/dev/null | awk '{print $2; exit}')

  if [ -n "$externals" ] && [ "$lid" = "closed" ]; then
    for o in $externals; do xrandr --output "$o" --auto; done   # turn the external on first
    xrandr --output "$internal" --off
  elif [ -n "$externals" ]; then
    xrandr --output "$internal" --auto
    for o in $externals; do xrandr --output "$o" --auto --right-of "$internal"; done
  else
    xrandr --output "$internal" --auto
  fi
  restart_polybar
}

if [ "$1" = "watch" ]; then
  exec 9>/tmp/dock-watch.lock
  flock -n 9 || exit 0            # only one watcher at a time
  last=""
  while true; do
    now=$(state)
    if [ "$now" != "$last" ]; then
      sleep 1
      apply
      last=$(state)
    fi
    if ! pgrep -x polybar > /dev/null && flock -n /tmp/polybar-restart.lock true; then
      restart_polybar
    fi
    sleep 2
  done
fi
apply
