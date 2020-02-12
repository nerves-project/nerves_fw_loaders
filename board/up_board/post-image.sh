#!/usr/bin/env bash

set -e

# TARGETDIR=$1

FWNAME=nerves_fw_loader-up_board

$BR2_EXTERNAL_FIRMWARE_LOADERS_PATH/board/common/generate-readme.sh "the UP Board"

FWUP_CONFIG=$BR2_EXTERNAL_FIRMWARE_LOADERS_PATH/board/up_board/fwup.conf
FWUP=$HOST_DIR/usr/bin/fwup

FW_PATH=$BINARIES_DIR/$FWNAME.fw

# Build the firmware image (.fw file)
echo "Creating $FWNAME.fw..."
$FWUP -c -f "$FWUP_CONFIG" -o "$FW_PATH"

