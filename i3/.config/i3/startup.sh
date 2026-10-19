#!/bin/sh
# 1 = terminal, 2 = Firefox, then back to 1; 3-6 are placed by rules in the i3 config

# wait until a window whose class contains $1 appears (gives up after ~20s)
wait_for() {
  i=0
  while [ $i -lt 40 ]; do
    i3-msg -t get_tree | grep -qi "\"class\":\"[^\"]*$1" && return
    i=$((i+1))
    sleep 0.5
  done
}

i3-msg 'workspace number 1' > /dev/null
kitty &
wait_for kitty

i3-msg 'workspace number 2' > /dev/null
firefox &
wait_for firefox

i3-msg 'workspace number 1' > /dev/null

claude-desktop &
discord &
signal &
spotify &
