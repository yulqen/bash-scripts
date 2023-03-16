#!/usr/bin/env bash

# this script replaces tjclip fish function which relied on _tj.

# Our target file
TODAY_JOURNAL=~/Documents/Notes/journal/$(date +\%Y-\%m-\%d).md
URL="$(xclip -o clipboard clipboard)"

# Test whether it already exisits or not
if [[ -a $TODAY_JOURNAL ]]
then
        JLINE="- $(date +'%H:%M'): $1"
        echo "$JLINE: $URL." >> "$TODAY_JOURNAL"
else
    touch "$TODAY_JOURNAL"
    header_date="$(date +'%A %d %b %Y')"
    {   echo -e "# $header_date\n"
    } >> "$TODAY_JOURNAL"
        JLINE="- $(date +'%H:%M'): $1"
        echo "$JLINE: $URL." >> "$TODAY_JOURNAL"
fi
