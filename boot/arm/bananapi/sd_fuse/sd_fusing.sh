#!/bin/sh
#
# Copyright (C) 2015 Hardkernel Co,. Ltd
# Dongjin Kim <tobetter@gmail.com>
#
# SPDX-License-Identifier:	GPL-2.0+
#

DIR=$(dirname "${0}")

UBOOT="${DIR}/u-boot-sunxi-with-spl.bin"

if [ -z $1 ]; then
        echo "Usage ./sd_fusing.sh <SD card reader's device>"
        exit 1
fi

if [ ! -f $UBOOT ]; then
        echo "error: $UBOOT is not exist"
        exit 1
fi

echo "Writing bootloader/Uboot to $1."
sudo dd if=$UBOOT of=$1 conv=fsync bs=1024 seek=8
sync

echo Finished.
