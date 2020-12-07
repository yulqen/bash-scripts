#!/bin/sh -e

# to echo from stdin
#stdin=$(cat)

# if [ -z $stdin ] ; then
#     echo "No stdin set"
# fi

# echo $stdin

# DESCRIPTION=$1
# echo $DESCRIPTION

if [[ $# < 1 || $# > 3 ]] ; then
    echo "You need to give me three parameters. Expect DATE TIME DESCRIPTION."
    exit 1
else
    DATE="$1"
    TIME="$2"
    DESCRIPTION="$3"
fi

dateRegex='^[[:digit:]]{,2} [[:alpha:]]+ [[:digit:]]{4,4}$'
timeRegex='^[[:digit:]]{2,2}\:[[:digit:]]{2,2}$'

if [[ ! $DATE =~ $dateRegex ]] ; then
    echo "Date must be of format: D[D] MONTH YYYY"
    exit 1
fi

if [[ ! $TIME =~ $timeRegex ]] ; then
    echo "Time must be of format: HH:MM"
    exit 1
fi

DESC_LENGTH=$(expr length $DESCRIPTION)
echo $DESC_LENGTH

if (($DESC_LENGTH > 2)) ; then
    echo "Sorry, that is too long a description... Less than 2."
    exit 1
fi

if [[ -z "${TW_HOOK_REMIND_REMOTE_HOST}" ]] ; then
    echo "There is not TW_HOOK_REMIND_REMOTE_HOST variable set."
    exit 1;
else
    echo "TW_HOOK_REMIND_REMOTE_HOST set"
fi

COMMAND="REM $DATE AT $TIME +15 *5 MSG $DESCRIPTION"

ssh $TW_HOOK_REMIND_REMOTE_HOST '
cat ~/.reminders/work.rem
'
echo $COMMAND
exit 0
