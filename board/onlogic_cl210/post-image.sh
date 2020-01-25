#!/usr/bin/env bash

set -e

# TARGETDIR=$1
FWNAME=$2

if [[ -z $FWNAME ]]; then
    FWNAME=onlogic_cl210-$(git -C "$BR2_EXTERNAL_FIRMWARE_LOADERS_PATH" describe --dirty)
fi

FWUP_CONFIG=$BR2_EXTERNAL_FIRMWARE_LOADERS_PATH/board/onlogic_cl210/fwup.conf
FWUP=$HOST_DIR/usr/bin/fwup

FW_PATH=$BINARIES_DIR/$FWNAME.fw

# Build the firmware image (.fw file)
echo "Creating $FWNAME.fw..."
$FWUP -c -f "$FWUP_CONFIG" -o "$FW_PATH"

