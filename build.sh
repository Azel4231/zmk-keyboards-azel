#!/bin/bash

# cd to zmk dir (which happens to be in IdeaProjects, because I created the dev-container using IntelliJ)
cd /IdeaProjects/zmk

# build azelus6 for Seeed XIAO BLE, all others for nice!nano
if [[ "$1" == azelus6* ]]; then
  BOARD=seeeduino_xiao_ble
else
  BOARD=nice_nano
fi

# Build with ZMK Studio settings.
west build -s app -p -b "$BOARD" -S studio-rpc-usb-uart -- -DZMK_CONFIG=/tmp/zmk-config/config -DSHIELD=$1 -DZMK_EXTRA_MODULES=/workspaces/zmk-modules -DCONFIG_ZMK_STUDIO=y
# copy compiled firmware to the docker volume to transfer to the host machine
cp build/zephyr/zmk.uf2 /workspaces/zmk-modules/output
cd /