#!/bin/bash


mount -t nfs -o vers=4 rimsky.banded-neon.ts.net:/matt /srv/nfs/rimsky/matt
mount -t nfs -o vers=4 rimsky.banded-neon.ts.net:/music /srv/nfs/rimsky/music
