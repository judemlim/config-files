#!/bin/bash
DIRECTION=$1

CURRENT_WINDOW=$(xdotool getwindowfocus)
CHROMIUM_PID_LIST=$(xdotool search --classname Chromium)
VLC_PID_LIST=$(xdotool search --classname vlc)
# sed to extract window numer
CURRENT_MOUSE_WINDOW=$(xdotool getmouselocation --shell | grep WINDOW | sed 's/[^0-9]*//g')

for PID in $CHROMIUM_PID_LIST; do
  if [[ "$CURRENT_MOUSE_WINDOW" = "$PID" ]]; then
    case $1 in
      prev)
        xdotool key Control+Next
        ;;
      next)
        xdotool key Control+Prior
        ;;
    esac
    exit 0
  fi
done
case $1 in
  prev)
    i3-msg "workspace prev"
    ;;
  next)
    i3-msg "workspace next"
    ;;
esac
