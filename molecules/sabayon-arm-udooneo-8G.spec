%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/arm-base.common

%env source_chroot: ${SABAYON_MOLECULE_HOME:-/sabayon}/sources/udooneo

packages_to_add:
	app-misc/sabayon-skel,
	net-misc/networkmanager,
	openssh,
	sys-apps/keyboard-configuration-helpers,
	sys-process/vixie-cron

packages_to_remove:

# Release desc (the actual release description)
release_desc: armv7l Udoo Neo

# Release Version (used to generate release_file)
%env release_version: ${SABAYON_RELEASE:-11}

# Specify image file name (image file name will be automatically
# produced otherwise)
%env image_name: Sabayon_Linux_${SABAYON_RELEASE:-11}_armv7l_Udoo_Neo_8GB.img

# Specify the image file size in Megabytes. This is mandatory.
# To avoid runtime failure, make sure the image is large enough to fit your
# chroot data.
image_mb: 7200

# Path to boot partition data (MLO, u-boot.img etc)
%env source_boot_directory: ${SABAYON_MOLECULE_HOME:-/sabayon}/boot/arm/udooneo

# External script that will generate the image file.
# The same can be copied onto a MMC by using dd
%env image_generator_script: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/udoo_neo_image_generator_script.sh


