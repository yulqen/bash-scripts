#!/bin/sh

qemu-system-x86_64 -hda /home/lemon/vms/os/openbsd7.6/openbsd.qcow2 -nic user,hostfwd=tcp::10022-:22 -serial mon:stdio -nographic
