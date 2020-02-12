#!/bin/sh

BOARD_NAME=$1
VERSION=v$(cat "$BR2_EXTERNAL_FIRMWARE_LOADERS_PATH/VERSION")

cat << EOF > "$BINARIES_DIR/readme.txt"
# Nerves Firmware Loader for $BOARD_NAME

This USB Flash drive will load a firmware image or run a script on a device
that is intended to boot off internal memory (e.g., eMMC or SSD).

To load a firmware image, copy your firmware file to this directory and call it
'install.fw'. Unmount this drive and plug it into the device. Boot the device
and watch the lights or messages on HDMI to see it program the internal memory.

To run a shell script, copy that script to this directory and call it
'install.sh'.  The shell script environment contains few commands than normal.
To experiment, don't copy anything to the Flash drive, then put the Flash drive
in the device and boot. It will fail, but you should be able to log in as the
user "root". There is no password.

See https://github.com/nerves-project/nerves_fw_loaders for more documentation.

## Build information

nerves_fw_loaders version: $VERSION
Buildroot version: $BR2_VERSION
EOF

