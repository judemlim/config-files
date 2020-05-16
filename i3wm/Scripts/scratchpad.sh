#!/bin/bash
# Author: Jude Lim
# Created: 12/05/2020
# 
# Description: 
# Script is run in i3 whenever $mod4+r or $mod4+t is pressed. It toggles the visibility  of 
# the "dropdown" and "file_explorer" windows, which are stored in i3's scratchpad


CURRENT_WINDOW=$(xdotool getwindowfocus)

ACTIVE_DD=$(xdotool search --classname dropdown)
ACTIVE_FE=$(xdotool search --classname file_explorer)

OPEN_DD="i3-msg 'exec --no-startup-id urxvt -name dropdown;'"
OPEN_FE="i3-msg 'exec --no-startup-id urxvt -name file_explorer -e ranger'"

TOGGLE_DD="i3-msg '[instance="dropdown"] scratchpad show; [instance="dropdown"] move position center'"
TOGGLE_FE="i3-msg '[instance="file_explorer"] scratchpad show; [instance="file_explorer"] move position center'"

case $1 in
    t)
        if [[ "$CURRENT_WINDOW" = "$ACTIVE_FE" ]]; then
            # Hides File explorer if it is active
            eval "$TOGGLE_FE"
        fi
        eval "$TOGGLE_DD"

        # if dropdown is not open then we enter if condition 
        if [[ $? -ne 0 ]]; then
            eval "$OPEN_DD"
            sleep 0.2
            eval "$TOGGLE_DD"
        fi
        ;;
    r)
        if [[ "$CURRENT_WINDOW" = "$ACTIVE_DD" ]]; then
            # Hides dropdown if it is active
            eval "$TOGGLE_DD"
        fi
        eval "$TOGGLE_FE"

        # if file explorer is not open then we enter if condition 
        if [[ $? -ne 0 ]]; then
            eval "$OPEN_FE"
            sleep 0.2
            eval "$TOGGLE_FE"
        fi
        ;;
esac


