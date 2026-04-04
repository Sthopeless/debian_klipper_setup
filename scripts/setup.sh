#!/bin/bash

KIAUH_REPO="https://github.com/dw-0/kiauh"
HELIXSCREEN_REPO="https://github.com/prestonbrown/helixscreen.git"

# dependencies=(git curl libdrm2 libgbm1 libinput10 libudev1 libdbus-1-3)
dependencies=(git curl ffmpeg)
to_install=()

for pkg in "${dependencies[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
        echo "$pkg is missing."
        to_install+=("$pkg")
    fi
done

if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing: ${to_install[*]}..."
    sudo apt-get update
    sudo apt-get install -y "${to_install[@]}"
fi

install_kiauh () {
    if [ ! -d "$HOME/kiauh" ]; then
        cd ~/
        git clone "$KIAUH_REPO" "$HOME/kiauh"
    fi
}

install_helixscreen () {

    if [ ! -d "$HOME/kiauh/kiauh/extensions/helixscreen" ]; then
        cd ~/
        git clone --depth 1 "$HELIXSCREEN_REPO" /tmp/helixscreen
        cp -r /tmp/helixscreen/scripts/kiauh/helixscreen ~/kiauh/kiauh/extensions/
        rm -rf /tmp/helixscreen
    fi    
}

install_timelapse () {
    if [ ! -d "$HOME/kiauh/kiauh/extensions/timelapse" ]; then
        cd ~/
        git clone https://github.com/mainsail-crew/moonraker-timelapse.git
        cd ~/moonraker-timelapse
        make install

        # # moonraker.conf
        # [update_manager timelapse]
        # type: git_repo
        # primary_branch: main
        # path: ~/moonraker-timelapse
        # origin: https://github.com/mainsail-crew/moonraker-timelapse.git
        # managed_services: klipper moonraker
    fi    
}
remove_helixscreen () {
    if [ -d "$HOME/kiauh/kiauh/extensions/helixscreen" ]; then
        echo "Removing Helixscreen..."
        rm -rf "$HOME/kiauh/kiauh/extensions/helixscreen"
    fi
}

install_kiauh
install_timelapse
install_helixscreen

echo "Launching KIAUH. Please install Klipper, Moonraker, and Fluidd manually via the UI."
~/kiauh/kiauh.sh
