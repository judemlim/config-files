#!/bin/bash
DIRECTION=$1

CURRENT_MOUSE_WINDOW=$(xdotool getmouselocation --shell | grep WINDOW | sed 's/[^0-9]*//g')
CHROMIUM_PID_LIST=$(xdotool search --classname Chromium)

for PID in $CHROMIUM_PID_LIST; do
  if [[ "$CURRENT_MOUSE_WINDOW" = "$PID" ]]; then
        xdotool key Control+t
    exit 0
  fi
done

xfce4-appfinder
