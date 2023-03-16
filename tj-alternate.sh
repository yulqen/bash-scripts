#!/usr/bin/env bash

# This script replaces the _tj as the main functionality of the tj fish function, as wash. We don't need
# the fish function any more - this does the job.

# Our target file
TODAY_JOURNAL=~/Documents/Notes/journal/$(date +\%Y-\%m-\%d).md

# Test whether it already exisits or not
if [[ -a $TODAY_JOURNAL ]]
then
        JLINE="- $(date +'%H:%M'): $1"
        echo "$JLINE" >> "$TODAY_JOURNAL"
else
    touch "$TODAY_JOURNAL"
    header_date="$(date +'%A %d %b %Y')"
    {   echo -e "# $header_date\n"
    } >> "$TODAY_JOURNAL"
        JLINE="- $(date +'%H:%M'): $1"
        echo "$JLINE" >> "$TODAY_JOURNAL"
fi
