# ZMK Config for my Keyboards

Unibody split keyboards with simple layer-based keymaps. No home-row mods or other advanced behaviors. The keymap uses a few combos and has deactivated tri-layers for playing with OS dependent keymaps. That's all.

## Core aspects

* Config as a module for "proper" zmk integration, and to support container-based builds (including github actions)
* ZMK Studio support
* Support for german keyboard layout and characters (forked from https://github.com/joelspadin/zmk-locales)
* Support for MacOS symbols (see keys_de.h)

## Todos

* build all keyboards/shields in one go
* build all keyboards/shields with the same keymap file

## Notes on building

### Create Dev-Container

#### Create Volumes (instructions from documentation):
 ``` 
 docker volume create --driver local -o o=bind -o type=none -o device="/<path-to-home-dir>/github/zmk-keyboards-azel" zmk-modules
 ```
(or whatever your zmk-module is called)

#### Init/Update dev-container:

This is required after initial setup and after changing the module path, which in turn requires recreating docker volumes as well as the dev-container.

In IntelliJ:
* Clone https://github.com/zmkfirmware/zmk
* rightclick .devcontainer/devcontainer.json
* Dev Containers -> Create Dev Container and Clone Sources

Then (also in IntelliJ with connected Docker daemon):
* Docker (View) -> Dev Containers
* (dev-container-name) -> Run
* (dev-container-name) -> Terminal

Inside container:
* init zmk toolchain:
```
west init -l app/
```
* update toolchain
``` 
west update
```

### Build in container

Commands for building the firmeware with ZMK-Studio support. Keep in mind that studio only supports eight layers total. Don't put &bootloader and &studio_unlock on layer nine like me ;-)

In IntelliJ:

* Docker (View) -> Dev Containers
* (dev-container-name) -> Run
* (dev-container-name) -> Terminal

#### Inside container

Variant 1:
```
cd /IdeaProjects/zmk
west build -s app -p -b nice_nano_v2 -S studio-rpc-usb-uart -- -DZMK_CONFIG=/tmp/zmk-config/config -DSHIELD=azelus3 -DZMK_EXTRA_MODULES=/workspaces/zmk-modules -DCONFIG_ZMK_STUDIO=y
cp build/zephyr/zmk.uf2 /workspaces/zmk-modules/output
```
-p = "pristine" build. Useful when building different shields consecutively. Prevents ZMK from caching and using the wrong overlay files (from other shields).

/workspaces/zmk-modules is (one of) the mounted docker volumes that lets us copy outside the container.

Variant 2:

First copy build.sh to container root directory (required only once):
```
cp /workspaces/zmk-modules/build.sh .
```
Then run it:
```
bash build.sh
```

#### Outside container

* Put your controller into bootloader mode, either via double-click on reset or by pressing the &bootloader key (configured previously)
* It should connect as a thumb-drive automatically
* Copy the firmware to the mounted nice nano:
```
cp output/zmk.uf2 /Volumes/NICENANO
```
* MacOS: /Volumes/NICENANO
* Linux: /media/"User"/NICENANO

### Old notes (obsolete)

When installing the toolchain locally you can build without a module. Assumes keyboard files in boards/shields/azelus3.

#### Build

```
cd github/zmk/app
west build -p -b nice_nano_v2 -- -DSHIELD=azelus3         
# reset controller
cp build/zephyr/zmk.uf2 /<path-to-mount-dir>/NICENANO/
```

-p = "pristine" build. Useful when building different shields consecutively. Prevents ZMK from caching and using the wrong overlay/keymap files (from other shields).

#### Build for ZMK Studio

First activate west venv, where python lib protobuf is installed. Then build.
```
source /<path-to-home-dir>/.local/share/pipx/venvs/west/bin/activate
west build -p -d build/cl_studio -b nice_nano_v2 -S studio-rpc-usb-uart -- -DSHIELD=azelus3 -DCONFIG_ZMK_STUDIO=y
# reset controller
cp build/cl_studio/zephyr/zmk.uf2 /<path-to-mount-dir>/NICENANO/
```

#### Notes
Installing/Updating Python dependencies (e.g. protobuf) inside the west venv managed by pipx (e.g. Ubuntu):
```
~/.local/share/pipx/venvs/west/bin/python3.12 -m pip install protobuf grpcio-tools
```
(not wanting to struggle with python dependencies on top of everything else is a good reason for following the container route above)