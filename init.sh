#!/bin/bash
# sudo apt-get update
# set env
#coreutils
CUR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ENV="env/entry.sh"

# add "source $CUR/$ENV >> $HOME/.bashrc" to "~/.bashrc"
if ! grep -qF "source $CUR/$ENV" "$HOME/.bashrc"; then
        echo "source $CUR/$ENV" >> $HOME/.bashrc
        source $HOME/.bashrc
fi

# for pip install
# add "export PATH="$HOME/.local/bin" to "~/.bashrc"
if ! grep -qF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
        source $HOME/.bashrc
fi

# for vimrc
# add "export PATH="$HOME/.local/bin" to "~/.bashrc"
if ! grep -qF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.vimrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
        source $HOME/.bashrc
fi

# create dirs
DIR=(
        mypro project pkg tmp tools
        .ssh
)
for dir in ${DIR[@]}
do
        mkdir -p $HOME/$dir
done

# generate ssh key
if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
        ssh-copy-id $(whoami)@localhost
        echo "PubkeyAcceptedKeyTypes +ssh-rsa" >> ~/.ssh/config
        echo "------------This is your ssh public key---------------"
        cat $HOME/.ssh/id_rsa.pub
        echo "-------------------------------------------------------"
else
        echo "ssh key already exists"
fi
read -p "would you want to set git config ?[Y/N]" ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        # config git config
        read -p "input your email: " EMAIL
        read -p "input your name: " NAME
        if [ -z "$EMAIL" ] || [ -z "$NAME" ]; then
                echo "email or name cannot be empty continue..."
        else
                git config --global user.email $EMAIL
                git config --global user.name $NAME
        fi
        
fi

read -p "would you want to use vim config ?[Y/N]" ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        # config vim config
        echo "source $CUR/vim/vimrc" >> $HOME/.vimrc
fi

read -p "would you want to install pkg.sh ?[Y/N]" ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        chmod +x ./pkg.sh && ./pkg.sh
fi