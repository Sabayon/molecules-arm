#!/bin/bash
set -e

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

echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-binfmt:' > /proc/sys/fs/binfmt_misc/register || true

update_docker_companion
update_chroot sabayon/rpi-armhfp rpi
#update_chroot sabayon/rpi-armhfp bananapi
update_chroot sabayon/rpi-mc-armhfp rpi-mc
update_chroot sabayon/odroid-u2-x2-armhfp odroid-u2-x2
update_chroot sabayon/odroid-c2-armhfp odroid-c2
update_chroot sabayon/udooneo-armhfp udooneo

export SABAYON_RELEASE="${SABAYON_RELEASE:-16}"

echo "Release ${SABAYON_RELEASE}"

SABAYON_MOLECULE_HOME=$(pwd) molecule molecules/sabayon-arm-rpi-8G.spec
SABAYON_MOLECULE_HOME=$(pwd) molecule molecules/sabayon-arm-rpi-mc-8G.spec
SABAYON_MOLECULE_HOME=$(pwd) molecule molecules/sabayon-arm-odroid-u2-x2-8G.spec
SABAYON_MOLECULE_HOME=$(pwd) molecule molecules/sabayon-arm-odroid-c2-8G.spec
SABAYON_MOLECULE_HOME=$(pwd) molecule molecules/sabayon-arm-udooneo-8G.spec
#SABAYON_MOLECULE_HOME=$(pwd) molecule molecules/sabayon-arm-bananapi-8G.spec
