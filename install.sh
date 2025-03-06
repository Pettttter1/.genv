#!/bin/bash
# sudo apt-get update
# set env
#coreutils
CUR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ENV="$CUR/env/entry.sh"
VIMRC="$CUR/env/.vimrc"
BASHRC="$HOME/.bashrc"
SSHCONFIG="$HOME/.ssh/config"
INSTALL="$CUR/install"

# $1: string
# $2: file_name
function string_in_file {
        if grep -qF "$1" "$2"; then
                return 0
        else
                return 1
        fi
}

# write "source $CUR/$ENV >> $HOME/.bashrc" to $BASHRC
if ! string_in_file "source $ENV" $BASHRC; then
        echo "source $ENV" >> $BASHRC
fi

# write "export PATH="$HOME/.local/bin" to $BASHRC for pip install
if ! string_in_file 'export PATH="$HOME/.local/bin:$PATH"' $BASHRC; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> $BASHRC
fi

# apply the change
source $HOME/.bashrc

# create dirs
DIR=(
        mypro project pkg tmp tools
        .ssh
)
for dir in ${DIR[@]}
do
        mkdir -p $HOME/$dir
done

# write "PubkeyAcceptedKeyTypes +ssh-rsa" to $SSHCONFIG
if ! string_in_file "PubkeyAcceptedKeyTypes +ssh-rsa" $SSHCONFIG; then
        echo "PubkeyAcceptedKeyTypes +ssh-rsa" >> $SSHCONFIG
fi

# generate ssh key
if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
        ssh-copy-id $(whoami)@localhost
fi

# print ssh key
echo "--------------------ssh public key---------------------"
cat $HOME/.ssh/id_rsa.pub
echo "-------------------------------------------------------"

read -p "would you want to set git config ?[Y/N]" ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        read -p "input your email: " EMAIL
        read -p "input your name: " NAME
        if [ -z "$EMAIL" ] || [ -z "$NAME" ]; then
                echo "email or name cannot be empty continue..."
        else
                git config --global user.email $EMAIL
                git config --global user.name $NAME
        fi
fi

read -p "would you want to install pkg.sh ?[Y/N]" ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        source $INSTALL/pkg.sh
fi

read -p "would you want to use .vimrc ?[Y/N]" ANSWER
if [ "$ANSWER" = "Y" ] || [ "$ANSWER" = "y" ]; then
        echo "source $CUR/env/.vimrc" >> $HOME/.vimrc
fi