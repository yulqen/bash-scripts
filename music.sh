#!/bin/sh

# nicked from https://hmbrg.xyz/log/2021/listen-to-audio-collection-via-dmenu-mpv/
# ALl credit to them! Thank you.

###  -----------------------------------------------------------------
###  Global variables:
###  -----------------------------------------------------------------
DIR=~/music_mnt/annex/Music
PLAYER=mpv
DMENU='dmenu -i -l 30 -fn Iosevka-12 -nb #b96dbf -nf white'

###  -----------------------------------------------------------------
###  Select the subdirectory from which you want to play the MP3 file:
###  -----------------------------------------------------------------
albums=$(ls -1 "$DIR" | $DMENU -p "Select subdir: ")

###  -----------------------------------------------------------------
###  Select the subdirectory from which you want to play the MP3 file:
###  -----------------------------------------------------------------
album=$(ls -1 "$DIR/$albums" | $DMENU -p "Select album: ")

###  -----------------------------------------------------------------
###  Select MP3 file to play back:
###  -----------------------------------------------------------------
mp3=$(ls -1 "$DIR/$albums/$album/" | $DMENU -p "MP3 to play back: ")

###  -----------------------------------------------------------------
###  Play back selected MP3 file:
###  -----------------------------------------------------------------
$PLAYER "$DIR/$albums/$album/$mp3" --no-video

