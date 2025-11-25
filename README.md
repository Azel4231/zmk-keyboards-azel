# ZMK Config for my Keyboards

Unibody split keyboards with simple layer-based keymaps.

## Core aspects

* Config as a module for "proper" zmk integration, and to support container-based builds (including github actions)
* ZMK Studio support
* Support for german keyboard layout and characters (forked from https://github.com/joelspadin/zmk-locales)
* Support for MacOS symbols (see keys_de.h)

## Todos

* build all keyboards/shields in one go
* share keymap files between keyboards with similar physical layout

## Notes on building

Why a dev-container?
* A container-based build allows building firmware on a local machine without installing the whole ZMK/Zephyr toolchain (incl. python etc). The toolchain is instead installed inside the container. It's very similar to what the Github actions do.
* A Dev-Container allows accessing folders of the host system from inside the container (outside folders are mounted into folders inside the container). This makes it easy to edit the keymap in the host system, have it compile inside the container, and copy the resulting firmware file back out.  
* Local execution brings faster build times and a faster feedback loop when adjusting keymaps (no Github upload and wait for every change)

### Create Dev-Container

#### Create Volumes (instructions from documentation):
 ``` 
 docker volume create --driver local -o o=bind -o type=none -o device="/<path-to-home-dir>/github/zmk-keyboards-azel" zmk-modules
 ```

Notes:
* Adjust the path to match your github repo
* _zmk-modules_ is the name of the folder INSIDE the container that the (outside-) path gets mounted into.

#### Init/Update dev-container:

This is required:
* after initial setup
* after changing the module path, which in turn requires recreating docker volumes as well as the dev-container

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
* update toolchain incl. zmk
``` 
west update
```
* the config/west.yml defines which zmk version is being pulled. manifest.project.revision: master pulls master.  

### Build in container

Commands for building the firmware with ZMK-Studio support. Keep in mind that studio only supports eight layers total. Don't put &bootloader and &studio_unlock on layer nine like me ;-)

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

Run build.sh (with a shield name):
```
bash build.sh azelus2
```

Requires copying build.sh to container root directory beforehand:
```
cp /workspaces/zmk-modules/build.sh .
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