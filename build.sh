#!/bin/bash

# cd to zmk dir (which happens to be in IdeaProjects, because I created the dev-container using IntelliJ)
cd /IdeaProjects/zmk
# Build with ZMK Studio settings.
west build -s app -p -b nice_nano_v2 -S studio-rpc-usb-uart -- -DZMK_CONFIG=/tmp/zmk-config/config -DSHIELD=$1 -DZMK_EXTRA_MODULES=/workspaces/zmk-modules -DCONFIG_ZMK_STUDIO=y
# copy compiled firmware to the docker volume to transfer to the host machine
cp build/zephyr/zmk.uf2 /workspaces/zmk-modules/output

# build in cl_studio dir:
#west build -s app -d build/cl_studio -p -b nice_nano_v2 -S studio-rpc-usb-uart -- -DZMK_CONFIG=/tmp/zmk-config/config -DSHIELD=azelus3 -DZMK_EXTRA_MODULES=/workspaces/zmk-modules -DCONFIG_ZMK_STUDIO=y
#cp build/cl_studio/zephyr/zmk.uf2 /workspaces/zmk-modules/output