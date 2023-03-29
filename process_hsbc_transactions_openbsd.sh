#!/usr/local/bin/bash

tf="TransactionHistory.csv"

# Automatic cleanup
trap 'rm -f "$tmpfile"' EXIT
tmpfile=$(mktemp) || exit 1

trap 'rm -f "$ledgertmp"' EXIT
ledgertmp=$(mktemp) || exit

# Check for presence of transaction file
if [[ -a ~/Downloads/$tf ]]; then tpath=~/Downloads/$tf
elif [[ -a "$(pwd)/$tf" ]]; then tpath="$(pwd)/$tf"
else "Cannot find $tf. Expecting it either in ~/Downloads or in current folder."; exit 1
fi

# remove the BOM (https://stackoverflow.com/questions/45240387/how-can-i-remove-the-bom-from-a-utf-8-file)
sed -i $'1s/^\uFEFF//' "$tpath"

# read the file and process lines
while read -r line; do
    line=${line//"-"/"£"}
    echo -e "$line\n$(cat "$tmpfile")" > "$tmpfile"
done < "$tpath"

# how to append to a text file in bash
echo -e "Date,Description,Amount\n$(cat "$tmpfile")" > "$tmpfile"

# use ledger to convert to ledger format
ledger convert --input-date-format "%d/%m/%Y" "$tmpfile" > "$ledgertmp"

# Remove the erroneous Equity lines
sed -i '/Equity:Unknown/d' "$ledgertmp"

# dump to sdout for further redirection
cat "$ledgertmp"
