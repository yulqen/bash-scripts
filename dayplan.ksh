#!/bin/ksh

# our target file
DATE=$(date +\%Y-\%m-\%d)

if [ $# -ne  0 ]
then
  DATE=$1
fi

TODAY_PLANNER=~/Notes/journal/day_plans/$DATE.txt

if [[ -a $TODAY_PLANNER ]]
then
  vim "$TODAY_PLANNER"
else
  touch "$TODAY_PLANNER"
  {
    echo -e "Date: $DATE

Goal for Today: [replace this with your goal]
---

08:15 - 08:20 - Harvey to school
08:45 - 09:00 - Sophie to school
09:15 - 09:30 - Email 
09:30 - 10:00 - 
10:00 - 11:00 - 
11:00 - 12:00 - 
12:15 - 13:00 - Lunch
13:00 - 14:00 - 
14:00 - 15:00 -
15:00 - 16:00 - 
16:00 - 17:00 - "
  } > "$TODAY_PLANNER"
  vim "$TODAY_PLANNER"
fi
