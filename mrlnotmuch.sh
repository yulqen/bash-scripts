#!/bin/sh

notmuch new > /dev/null 2>&1
notmuch tag +emacs from:info@protesilaos.com > /dev/null 2>&1
notmuch tag +list +emacs to:~protesilaos/denote@lists.sr.ht > /dev/null 2>&1
notmuch tag +list from:ek@eleanorkonik.com > /dev/null 2>&1
notmuch tag +receipt from:platform@parentpay.com > /dev/null 2>&1
notmuch tag +todo +unread from:matt@matthewlemon.com to:madmin+task@rushpost.com > /dev/null 2>&1
notmuch tag +school from:SC9294404a@schoolcomms.com > /dev/null 2>&1
notmuch tag +school from:27ED003@groupcallalert.com > /dev/null 2>&1
notmuch tag +deleted from:verify@twitter.com > /dev/null 2>&1
notmuch tag +marketing from:team@news.wakingup.com > /dev/null 2>&1



