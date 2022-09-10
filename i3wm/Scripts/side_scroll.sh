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
        xdotool key Control+Prior
        ;;
      next)
        xdotool key Control+Next
        ;;
    esac
    exit 0
  fi
done
case $1 in
  prev)
    if [[ $DESKTOP_SESSION = "xmonad" ]]; then
      xdotool key Super+Left
    else
      i3-msg "workspace prev"
    fi
    ;;
  next)
    if [[ $DESKTOP_SESSION = "xmonad" ]]; then
      xdotool key Super+Right
    else
      i3-msg "workspace next"
    fi
    ;;
esac
