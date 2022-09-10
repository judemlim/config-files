#!/bin/sh
xrandr | grep primary | grep -q x1440 
if [[ $? = 0 ]]; then 
    feh --randomize --bg-scale /home/judemlim/Pictures/System\ images/3440x1440_wallpaper/*
else
    feh --randomize --bg-scale /home/judemlim/Pictures/System\ images/1080_wallpaper/*
fi

