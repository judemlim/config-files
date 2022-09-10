#!/bin/sh

CHROMIUM_PID_LIST=$(xdotool search --classname Chromium)
CURRENT_WINDOW=$(xdotool getwindowfocus)

for PID in $CHROMIUM_PID_LIST; do
  if [[ "$CURRENT_WINDOW" = "$PID" ]]; then
    xdotool key CTRL+w
    exit 0
  fi
done

if [[ $DESKTOP_SESSION = "xmonad" ]]; then
  xdotool key Super+shift+c
else
  i3-msg "kill"
fi
