#!/bin/zsh

cd /IdeaProjects/zmk
west build -s app -p -b nice_nano_v2 -S studio-rpc-usb-uart -- -DZMK_CONFIG=/tmp/zmk-config/config -DSHIELD=azelus3 -DZMK_EXTRA_MODULES=/workspaces/zmk-modules -DCONFIG_ZMK_STUDIO=y
cp build/zephyr/zmk.uf2 /workspaces/zmk-modules/