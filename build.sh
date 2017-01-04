#!/bin/bash
set -e

IMAGES_ID=(
  "rpi"
  "rpi-mc"
  "rpi-mate"
  "rpi-openrc"
  "odroid-x2-u2"
  "odroid-c2"
  "odroid-c2-openrc"
  "beaglebone-openrc"
  "bananapi"
)


if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

check_python_version() {
    python -c 'import sys; sys.exit(not (0x020700b0 < sys.hexversion < 0x03000000))' 2>/dev/null || {
        echo "This script require python2.7 as default interpreter" 1>&2
        exit 1
    }
}

update_chroot() {

	local image=$1
	local chroot_name=$2

	pushd ./sources

		rm -rf $(pwd)/${chroot_name}
		[[ -e ./../bin/docker-companion ]] \
			&& ./../bin/docker-companion --pull unpack "${image}" $(pwd)/${chroot_name} \
			|| docker-companion --pull unpack "${image}" $(pwd)/${chroot_name}

	popd

}

update_docker_companion() {

	type docker-companion >/dev/null 2>&1 || {
	echo >&2 "Fetching docker-companion for you, and placing it under bin/"
	curl -s https://api.github.com/repos/mudler/docker-companion/releases/latest \
		| grep "browser_download_url.*amd64" \
		| cut -d : -f 2,3 \
		| tr -d \" \
		| wget -i - -N -O bin/docker-companion
	chmod +x bin/docker-companion
}

}


check_python_version

# Check if binfmt is set
[[ -f /proc/sys/fs/binfmt_misc/arm ]] && echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-binfmt:' > /proc/sys/fs/binfmt_misc/register || true

export SABAYON_RELEASE="${SABAYON_RELEASE:-16}"
echo "Building up Release ${SABAYON_RELEASE}"

update_docker_companion

#Generate armhfp images

update_chroot sabayon/armhfp armhfp
# Doing chroot rootfs .tar.gz
pushd sources/armhfp
	tar cpjf ../../images/Sabayon_Linux_${SABAYON_RELEASE}_armv7l.tar.bz2 .
popd

md5sum images/Sabayon_Linux_${SABAYON_RELEASE}_armv7l.tar.bz2  > images/Sabayon_Linux_${SABAYON_RELEASE}_armv7l.tar.bz2.md5

for image_name in "${IMAGES_ID[@]}" ; do
  echo "Building $image_name"
  update_chroot sabayon/$image_name-armhfp $image_name
  SABAYON_MOLECULE_HOME=$(pwd) molecule molecules/sabayon-arm-$image_name-8G.spec
done
