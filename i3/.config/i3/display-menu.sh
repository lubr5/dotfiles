#!/bin/sh
# Windows-style projection menu: PC screen only / Duplicate / Extend / Second screen only
internal=$(xrandr --query | awk '/^(eDP|LVDS)/ {print $1; exit}')
ext=$(xrandr --query | awk '/ connected/ && $1 !~ /^(eDP|LVDS)/ {print $1; exit}')
lid=$(cat /proc/acpi/button/lid/*/state 2>/dev/null | awk '{print $2; exit}')

if [ -z "$ext" ]; then
  dunstify -a display -t 2000 "No external display connected"
  exit 0
fi
if [ "$lid" = "closed" ]; then
  dunstify -a display -t 2500 "Lid is closed" "Using the external display only"
  exit 0
fi

choice=$(printf '%s\n' "PC screen only" "Duplicate" "Extend" "Second screen only" | dmenu -l 4 -i -p "Display:")

# the laptop panel's first (preferred) mode, used to make Duplicate line up
res=$(xrandr --query | awk -v o="$internal" '$1==o {f=1; next} f && /^ / {print $1; exit}')

case "$choice" in
  "PC screen only")     xrandr --output "$internal" --auto --primary --output "$ext" --off ;;
  "Duplicate")          xrandr --output "$internal" --mode "$res" --primary --output "$ext" --auto --same-as "$internal" --scale-from "$res" ;;
  "Extend")             xrandr --output "$internal" --auto --primary --output "$ext" --auto --right-of "$internal" ;;
  "Second screen only") xrandr --output "$ext" --auto --primary --output "$internal" --off ;;
  *) exit 0 ;;
esac

setsid -f ~/.config/i3/polybar-restart.sh > /dev/null 2>&1
