#!/bin/sh -e

# to echo from stdin
#stdin=$(cat)

# if [ -z $stdin ] ; then
#     echo "No stdin set"
# fi

# echo $stdin

# DESCRIPTION=$1
# echo $DESCRIPTION

echo "$# parameters given"

if [[ $# != 2 ]] ; then
    echo "You need to give me three parameters. Expect DATETIME (YYYYMMDDTHHMM) DESCRIPTION."
    exit 1
else
    DATETIME="$1"
    DESCRIPTION="$2"
fi

dateRegex='^([[:digit:]]{4,4})([[:digit:]]{2,2})([[:digit:]]{2,2})T([[:digit:]]{2,2})([[:digit:]]{2,2})$'

if [[ ! $DATETIME =~ $dateRegex ]] ; then
    echo "Date must be of format: YYYYMMDDTHHMM"
    exit 1
fi

echo ${BASH_REMATCH[1]}
echo ${BASH_REMATCH[2]}
echo ${BASH_REMATCH[3]}

year=${BASH_REMATCH[1]}
month=${BASH_REMATCH[2]}
day=${BASH_REMATCH[3]}

# echo ${BASH_REMATCH[4]}



DESC_LENGTH=$(expr length $DESCRIPTION)
echo $DESC_LENGTH

if (($DESC_LENGTH > 50)) ; then
    echo "Sorry, that is too long a description... Less than 50 please."
    exit 1
fi

if [[ -z "${TW_HOOK_REMIND_REMOTE_HOST}" ]] ; then
    echo "TW_HOOK_REMIND_REMOTE_HOST environment variable is not set. Set it to hostname of target machine."
    exit 1;
else
    echo "TW_HOOK_REMIND_REMOTE_HOST set"
fi

COMMAND="REM $DATETIME AT $TIME +15 *5 MSG $DESCRIPTION"

ssh $TW_HOOK_REMIND_REMOTE_HOST '
cat ~/.reminders/work.rem
'
echo $COMMAND
exit 0
