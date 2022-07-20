#!/usr/local/bin/bash

# ripping off https://github.com/colindean/hejmo/blob/master/scripts/t

timelog="/home/lemon/Documents/Budget/ledger/2021/timetracking.ledger"

# clock in
_t_in() {
  printf "i %s %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>  "$timelog"
}

# clock out
_t_out() {
  printf "o %s %s" "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>  "$timelog"
}

_t_cur() {
  sed -e '/^i/!d;$!d' "${timelog}"
}

_t_bal() {
	ledger -f "${timelog}" bal
}

_t_reg() {
	ledger -f "${timelog}" reg
}

# this doesn't work in OpenBSD because of the date issue
# look for another way to calcuate relative dates
_t_start() {
  if [[ ! -z "$(_t_cur)" ]]; then
    echo "Cannot add an entry when one is checked out. Run '$(basename $0) out' to check out first."
    exit 1
  fi
  local start_date="$(date --date "${1}" '+%Y-%m-%d %H:%M:%S')"
  if [[ -z "${start_date}" ]]; then
    exit 1 #rely on date to have shown the error
  fi
  echo i "${start_date}" "${2}" >> "${timelog}"
}

# this doesn't work in OpenBSD because of the date issue
# look for another way to calcuate relative dates
_t_end() {
  local end_date
  if [[ -z "${1}" ]]; then
    _t_out "${@}"
    return 0
  fi
  end_date="$(date --date "${1}" '+%Y-%m-%d %H:%M:%S')"
  if [[ -z "${end_date}" ]]; then
    exit 1 #rely on date to have shown the error
  fi
  echo o "${end_date}" >> "${timelog}"
}

# Explicitly log a start and end
_t_log() {
  _t_start "${1}" "${3}"
  _t_end "${2}"
}

action=$1; shift

case "$action" in
  in) _t_in "$@";;
  out) _t_out "$@";;
	cur) _t_cur "$@";;
	bal) _t_bal "$@";;
  reg) _t_reg "$@";;
#	log) _t_log "$@";;
esac

exit 0
