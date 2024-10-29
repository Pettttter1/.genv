#!/bin/bash
# required packages for new environment

net() {
        # configure network
        ip a
        sudo ip link set ens33 up && sudo dhclient ens33
        sudo apt update
}

PKGS=(
        # process management
        htop
        btop
        plocate
)
sudo apt install -y git vim gcc meson cmake pip clang
# upgrade meson
sudo python3 -m pip install --upgrade meson pip ninja
#network
sudo apt install -y net-tools openssh-server
# sudo systemctl enable ssh --now
# sudo systemctl start ssh

#ssh-copy-id username@remote-server

# fzf
read -p "would you want to install fzf ?[Y/N]" ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi