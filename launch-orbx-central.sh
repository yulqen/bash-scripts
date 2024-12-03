#!/bin/sh

DIR=$HOME/Flight_Sim_Downloads/Orbx

binary=$(ls $DIR)
$("$DIR/$binary" --disable-gpu-sandbox)

