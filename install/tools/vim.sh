#!/bin/bash

MAX_TIME=300 
TRY_TIMES=5
repo_https=https://github.com/vim/vim.git
repo_git=git@github.com:vim/vim.git # if failed use it to try
VIM_PATH="$HOME/pkg"

read -p "input target directory(absolute path) or use default($DEFAULT_PATH)" TMP_PATH
if [ "$TMP_PATH" = "Y" ] || [ "$TMP_PATH" = "y" ] || ["$TMP_PATH" = ""]; then
        VIM_PATH=$TMP_PATH
fi

if [ ! -d $VIM_PATH ]; then
       echo "directory $VIM_PATH not exist"
       return 0
fi

# get vim repo
for ((i=0; i<$TRY_TIMES; i++)); do
        if [ ! -d $VIM_PATH/$(basename $repo_https .git) ]; then
                echo "get vim from $repo_https"
                if timeout "$MAX_TIME" git clone $repo_https $VIM_PATH/$(basename $repo_https .git); then
                        echo "Git clone successful."
                        break
                fi
        else
                echo "vim already exist in $VIM_PATH"
                break
        fi
done

if [ ! -d $VIM_PATH/$(basename $repo_https .git) ]; then
        echo "get vim from $repo_https failed"
        return 0
fi

sudo apt remove -y vim
# compile and install vim
cd $VIM_PATH/$(basename $repo_https .git)
sudo make distclean
sudo ./configure  --enable-python3interp --with-python-config-dir=/usr/lib/python3.10/config-3.10-x86_64-linux-gnu/
sudo make && sudo make install
cd -
source $HOME/.bashrc