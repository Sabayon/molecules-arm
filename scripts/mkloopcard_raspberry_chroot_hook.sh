#!/bin/bash

/usr/sbin/env-update
. /etc/profile

. /mkloopcard_chroot.include || exit 1

#setup_boot
#setup_users
#setup_bootfs_fstab "vfat"
# For kodi-raspberrypi
#echo 'SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"' > rpi2/etc/udev/rules.d/10-vchiq-permissions.rules
#usermod -a -G video sabayon

#/usr/sbin/rpi-update
#timedatectl set-ntp true

echo -5 | equo conf update
equo cleanup

exit 0
