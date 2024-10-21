#!/bin/bash
# sudo apt-get update
# set env
#coreutils
P=$(dirname "$0")
echo $P
ENV="env/entry.sh"
# exit 0
if ! grep -qF "source $P/$ENV" "$HOME/.bashrc"; then
        echo "source $P/$ENV" >> $HOME/.bashrc
fi

# generate ssh key
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
else
        echo "ssh key already exists"
fi
cat $HOME/.ssh/id_rsa.pub

# config git config
if [ -f "$HOME/.gitconfig" ]; then
        cat $HOME/.gitconfig
else
        git config --global user.email $1
        git config --global user.name $2
fi

ssh-copy-id $(whoami)@localhost
source $HOME/.bashrc