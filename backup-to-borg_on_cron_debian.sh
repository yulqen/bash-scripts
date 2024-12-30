#!/bin/sh

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=ssh://u423613@u423613.your-storagebox.de:23/./backups/matt_desktop

# See the section "Passphrase notes" for more infos.
export BORG_PASSPHRASE='unrevised -equation -bovine -spring'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --exclude 'home/*/.cache/*'     \
    --exclude '*/cache/*'     	    \
    --exclude '*Factorio/*'	    \
    --exclude '*Trash/*'	    \
    --exclude '*Zeal/*'	    	    \
    --exclude '*.m2l/*'	    	    \
    --exclude '*.local/share/*'     \
    --exclude '*.fgfs/*'     \
    --exclude '*/Steam/*'  	    \
    --exclude '*.mozilla/*'  	    \
    --exclude '*.venv/*'  	    \
    --exclude '*/venv/*'  	    \
    --exclude '*node_modules/*'     \
    --exclude '*.vscode/*'  	    \
    --exclude '*annex/*'  	    \
    --exclude '*ai_models/*'  	    \
    --exclude '*safetensors'  	    \
    --exclude '*lemon/X-Plane 12/*' \
    --exclude '*.npm/*'   	    \
    --exclude '*perl5/*'   	    \
    --exclude '*vms/*'   	    \
    --exclude '*.yarn/*'   	    \
                                    \
    ::'{hostname}-{now}'            \
    /etc                            \
    /home                           \
    /root                           \

backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-*' matching is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6

prune_exit=$?

# actually free repo disk space by compacting segments

info "Compacting repository"

borg compact

compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}
