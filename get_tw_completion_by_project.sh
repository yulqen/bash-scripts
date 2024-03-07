#!/bin/bash
#

if [ ! -n "$1" ] || [ $1 == "help" ]
then
    echo "You must pass a parameter to this script."
    echo "e.g. ./get_tw_completion_by_project.sh PROJECT DATE(ISO)"
fi

TASK=task
PROJECT=$1
SINCE=$2

$TASK project:"${PROJECT}" end.after:${SINCE} completed
