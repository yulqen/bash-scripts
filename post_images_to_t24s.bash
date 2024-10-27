#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    printf "\n\nUsage: post_images_to_t24s.bash TITLE SOURCEDIR_NAME\nTITLE should be lowercase with no spaces.\nSOURCEDIR_NAME is directory containing optimised JPGs.\n\
Don't be IN the sourcedir - point to it and don't bother with slashes.\n\nExample: post_images_to_t24s.bash day-out-in-berwick thumbnails.\n\n"
    exit 1
fi

date=$(date +'%Y-%m-%d')
title=$1
sourcedir=$2

rsync -avz "$(pwd)/$sourcedir/" pachelbel:/var/www/twentyfoursoftware.co.uk/pub/images/"$date-$title/"
