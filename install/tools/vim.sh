#!/bin/bash

MAX_TIME=300 
TRY_TIMES=5
repo_https=https://github.com/vim/vim.git
repo_git=git@github.com:vim/vim.git # if failed use it to try
DEFAULT_PATH="$HOME/pkg"

read -p "input target directory(absolute path) or use default($DEFAULT_PATH)" PATH
if [ "$PATH" = "Y" ] || [ "$PATH" = "y" ] || ["$PATH" = ""]; then
        PATH=$DEFAULT_PATH
fi

if [ ! -d $PATH ]; then
       echo "directory $PATH not exist"
       return 0
fi

# get vim repo
for ((i=0; i<$TRY_TIMES; i++)); do
        if [ ! -d $PATH/$(basename $repo_https .git) ]; then
                echo "get vim from $repo_https"
                if timeout "$MAX_TIME" git clone $repo_https $PATH/$(basename $repo_https .git); then
                        echo "Git clone successful."
                        break
                fi
        else
                echo "vim already exist in $PATH"
                break
        fi
done

if [ ! -d $PATH/$(basename $repo_https .git) ]; then
        echo "get vim from $repo_https failed"
        return 0
fi

sudo apt remove -y vim
# compile and install vim
cd $PATH/$(basename $repo_https .git)
sudo make distclean
sudo ./configure  --enable-python3interp --with-python-config-dir=/usr/lib/python3.10/config-3.10-x86_64-linux-gnu/
sudo make && sudo make install
cd -
source $HOME/.bashrc