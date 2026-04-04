#!/bin/bash

dependencies=(git curl apt-transport-https ca-certificates)
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

sudo apt-get remove -y docker.io docker-doc docker-compose podman-docker containerd runc

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian trixie stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER

newgrp docker
