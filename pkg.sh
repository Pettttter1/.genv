#!/bin/bash
# required packages for new environment

net() {
        # configure network
        ip a
        sudo ip link set ens33 up && sudo dhclient ens33
        sudo apt update
}

sudo apt install -y git vim gcc meson cmake pip clang
# upgrade meson
sudo python3 -m pip install --upgrade meson pip ninja
#network
sudo apt install -y net-tools openssh-server
# sudo systemctl enable ssh --now
# sudo systemctl start ssh

PKGS=(
        # process management
        htop
        btop
        plocate
)
echo "The following packages will be installed:"
for pkg in ${PKGS[@]}; do
    echo "$pkg"
done

read -p "Do you want to install these packages? (y/n) " ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        for pkg in ${PKGS[@]}
        do
                sudo apt install -y $pkg
        done
fi

#fzf
read -p "would you want to install fzf ?[Y/N]" ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        fzf --version
        if [ $? -ne 0 ]; then
                git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
                $HOME/.fzf/install
                source $HOME/.bashrc
        else
                echo "fzf already installed"
        fi
fi

# atuin
# if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
#         curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
# fi