#!/usr/bin/env bash

set -e

# TARGETDIR=$1

FWNAME=nerves_fw_loader-onlogic_cl210

FWUP_CONFIG=$BR2_EXTERNAL_FIRMWARE_LOADERS_PATH/board/onlogic_cl210/fwup.conf
FWUP=$HOST_DIR/usr/bin/fwup

FW_PATH=$BINARIES_DIR/$FWNAME.fw

# Build the firmware image (.fw file)
echo "Creating $FWNAME.fw..."
$FWUP -c -f "$FWUP_CONFIG" -o "$FW_PATH"

