#!/bin/bash
# required packages for new environment

net() {
        # configure network
        ip a
        sudo ip link set ens33 up && sudo dhclient ens33
        sudo apt update
}
PKGS=(
        plocate
)
sudo apt install -y git vim gcc meson cmake pip clang
# upgrade meson
sudo python3 -m pip install --upgrade meson pip ninja
#network
sudo apt install -y net-tools openssh-server
# sudo systemctl enable ssh --now
# sudo systemctl start ssh

DIR=(
        ~/project
        ~/pkg
        ~/tmp
        ~/tools
        ~/.ssh
)
for dir in ${DIR[@]}
do
        mkdir -p $dir
done
#ssh-copy-id username@remote-server
