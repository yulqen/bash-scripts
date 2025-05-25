#!/bin/sh
# When using LightDM, this script must be called from a file at  /usr/share/xsessions/dwm-custom.desktop of the form:
# 
# [Desktop Entry]
# Encoding=UTF-8
# Name=dwm (Custom - setting xrate, etc)
# Comment=Dynamic window manager with custom startup commands
# Exec=/usr/local/bin/startdwm.sh
# Icon=dwm
# Type=XSession
# 
# and then you are able to choose "dwm (Custom -setting xrate, etc)" in the LightDM menu top right.
#
#while true; do
#	xsetroot -name "$(date)"
#	sleep 2
#done


xset r rate 200 50
/home/lemon/.screenlayout/all_horiz.sh
#feh --bg-max --image-bg black --xinerama-index 0 /home/lemon/Pictures/Wallpapers/4Dec24__00002_.png
#feh --bg-center --image-bg black --randomize /home/lemon/Pictures/Wallpapers/*
feh --bg-max --image-bg black  /home/lemon/Pictures/Camera_Phone/IMG20231119124513.jpg --bg-max /home/lemon/Pictures/Camera_Phone/IMG20250507132129.jpg
#feh --recursive --bg-center --image-bg black  --randomize /home/lemon/Pictures/Wallpapers/* --bg-center  --randomize /home/lemon/Pictures/Wallpapers/*

setxkbmap -option ctrl:nocaps
# for status
dwmblocks &
# for clipmenu
clipmenud &
# redshift
redshift-gtk &
exec dwm
