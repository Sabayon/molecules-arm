#!/bin/sh
#
# mudler@sabayon.org
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
####################################

DIR=$(dirname "${0}")

if [ -z $1 ]
then
    echo "usage: ./sd_fusing.sh <SD Reader's device file>"
    exit 0
fi

if [ -b $1 ]
then
    echo "$1 reader is identified."
else
    echo "$1 is NOT identified."
    exit 0
fi

####################################
# fusing images

spl_position=1
uboot_position=69

#SPL fusing>
echo "SPL fusing"
dd iflag=dsync oflag=dsync if="${DIR}/SPL" of="${1}" seek="${spl_position}" || exit 1

#u-boot fusing>
echo "u-boot fusing"
dd iflag=dsync oflag=dsync if="${DIR}/u-boot.img" of="${1}" seek="${uboot_position}" || exit 1


####################################
#<Message Display>
echo "U-boot image is fused successfully."
