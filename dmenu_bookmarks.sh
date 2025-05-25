#!/bin/sh

xdotool type $(grep -v '^#' ~/.local/share/bookmarks.txt | dmenu -l 20 -fn monospace:size=24 | cut -d' ' -f1)
