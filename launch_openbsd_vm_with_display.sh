#!/bin/sh

qemu-system-x86_64 -cpu host -accel kvm -m 4096 -drive file=$HOME/vms/os/openbsd7.6/openbsd.qcow2 -display default
