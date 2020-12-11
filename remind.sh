#!/bin/sh -e

# to echo from stdin
#stdin=$(cat)

# if [ -z $stdin ] ; then
#     echo "No stdin set"
# fi

# echo $stdin

# DESCRIPTION=$1
# echo $DESCRIPTION

# Escape codes
eescape='\e[0m'
red='\e[31m'
green='\e[32m'
yellow='\e[33m'
brightyellow='\e[93m'

declare -A MONTHS=( [01]=January [02]=February [03]=March [04]=April [05]=May [06]=June [07]=July [08]=August [09]=September [10]=October [11]=November [12]=December )

remind_full="remind -z -k~/.virtualenvs/telegram-send/bin/telegram-send %s /home/lemon/.reminders"
remind_cmd="remind"

if [[ $# != 3 ]] ; then
    echo "You need to give me four parameters. Expect FILE DATETIME (YYYYMMDDTHHMM) DESCRIPTION."
    exit 1
else
    TARGETFILE="$1"
    DATETIME="$2"
    DESCRIPTION="$3"
fi
# Guard against bad file names
if [[ "$TARGETFILE" != "home" && "$TARGETFILE" != "work" ]] ; then 
    echo -e "${red}Please provide either 'work' or 'home' as the first argument.$eescape"
    exit 1
fi

dateRegex='^([[:digit:]]{4,4})([[:digit:]]{2,2})([[:digit:]]{2,2})T([[:digit:]]{2,2})([[:digit:]]{2,2})$'

if [[ ! $DATETIME =~ $dateRegex ]] ; then
    echo "Date must be of format: YYYYMMDDTHHMM"
    exit 1
fi

year=${BASH_REMATCH[1]}
month=${BASH_REMATCH[2]}
day=${BASH_REMATCH[3]}
hour=${BASH_REMATCH[4]}
min=${BASH_REMATCH[5]}

TIME="$hour:$min"

if (( $month > 12 )) ; then
    echo "Month number is too high."
    exit 1
fi

# debug messages
# echo "$# parameters given"
# echo -e "Got day $green$day$eescape."
# echo "Got month ${MONTHS[$month]}."
# echo "Got year $year."
# echo "Got hour $hour."
# echo "Got minute $min."

DESC_LENGTH=$(expr length "$DESCRIPTION")

if (($DESC_LENGTH > 50)) ; then
    echo -e "${red}Sorry, that is too long a description... Less than 50 please.$eescape"
    exit 1
fi

if [[ -z "${TW_HOOK_REMIND_REMOTE_HOST}" ]] ; then
    echo -e "${red}TW_HOOK_REMIND_REMOTE_HOST environment variable is not set. Set it to hostname of target machine.$eescape"
    exit 1;
else
    echo -e "${brightyellow}TW_HOOK_REMIND_REMOTE_HOST set to $TW_HOOK_REMIND_REMOTE_HOST${eescape}"
fi

COMMAND="REM $day ${MONTHS[$month]} $year AT $TIME +15 *5 MSG $DESCRIPTION %1"

# main 
# COMMENT THIS OUT WHEN TESTING ON LOCAL VM
# --------------
pid_cmd="pgrep remind"
remind_command_msg="${brightyellow}Run '$remind_full' in a tmux window on $TW_HOOK_REMIND_REMOTE_HOST.$eescape"
# first test if pid - if not exit (SCRIPT OBVIOUSLY WILL NOT PROCEED FOR TEST SERVER)
[[ -z $(ssh $TW_HOOK_REMIND_REMOTE_HOST "$pid_cmd") ]] && echo -e "${red}Failed to get remind PID. remind is not running.$eescape" && echo -e $remind_command_msg && exit 1
# -------------

ssh $TW_HOOK_REMIND_REMOTE_HOST "
echo "$COMMAND" >> ~/.reminders/${TARGETFILE}.rem
echo ''
echo '${TARGETFILE}.rem remind file is now:'
cat ~/.reminders/${TARGETFILE}.rem
"
exit 0
