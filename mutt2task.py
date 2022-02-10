#!/usr/bin/env python3
# -*- coding: utf-8 -*-

## About
# Add the subject of a mail as task to taskwarrior
# 
## Usage
# add this to your .muttrc:
# macro index,pager t "<pipe-message>~/path/to/mutt2task.py<enter>" 

# import libraries
import sys
import time
import email
from email.header import decode_header
from subprocess import call

# read from stdin and parse subject
x = sys.stdin.read()
x = email.message_from_string(x)
x = x['Subject']

# decode internationalized subject and transform ascii into utf8
x = decode_header(x)
x = ' '.join([t[0] for t in x])
x = x.encode('utf8')

# customize your own taskwarrior line
# use `x' to add the subject
call(['task', 'add', 'pri:L', '+mail', '--', x ])
print("Task added to taskwarrior. It has not been moved from the mutt inbox.")
time.sleep(2)
