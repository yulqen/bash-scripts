#!/bin/bash

# Save the current BORG_PASSCOMMAND value
OLD_BORG_PASSCOMMAND=$BORG_PASSCOMMAND

# Unset the BORG_PASSCOMMAND to force passphrase prompt
unset BORG_PASSCOMMAND

# Run the borg list command (replace /path/to/repo with your actual repository)
borg list ssh://u423613@u423613.your-storagebox.de:23/./backups/jo_macbook

# Restore the original BORG_PASSCOMMAND
export BORG_PASSCOMMAND="$OLD_BORG_PASSCOMMAND"

# Optional: Notify that the script has finished
echo "Borg list executed, and BORG_PASSCOMMAND restored."

