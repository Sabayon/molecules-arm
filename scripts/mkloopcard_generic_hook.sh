#!/bin/bash

/usr/sbin/env-update
. /etc/profile

. /mkloopcard_chroot.include || exit 1

setup_displaymanager
setup_desktop_environment
setup_users
setup_boot
#setup_bootfs_fstab "vfat"
#wget http://builder.mdrjr.net/tools/kernel-update.sh -O /usr/local/sbin/kernel-update.sh
#chmod +x /usr/local/sbin/kernel-update.sh
#/usr/local/sbin/kernel-update.sh

exit 0
