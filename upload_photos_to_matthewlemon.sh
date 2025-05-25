#!/bin/sh
 
# Make sure they are resized first:
#
# fdfind . ~/Pictures/Camera_Phone/ --type f --extension jpg --changed-within 1d -x cp {} /tmp/resize/
# 
# This will move all the files from today to /tmp/resize.
#
# Then do:
#
# mogrify -resize 30% -quality 80% *.jpg

# Make sure you are in the the directory of JPG files, then run this:

#
# ./upload_photos_to_matthewlemon.sh 2025-05-03-budle-bay

dir=$(pwd)
name=$1

echo "Uploading all the files in $dir"

rsync -avzh $(pwd)/*.jpg trevino:/var/public/images/"$1"/
