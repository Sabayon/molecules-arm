#!/bin/bash

/usr/sbin/env-update
. /etc/profile

. /mkloopcard_chroot.include || exit 1

setup_users
setup_boot

exit 0
