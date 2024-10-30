#!/bin/bash

MAX_TIME=300 
TRY_TIMES=5
repo_https=https://github.com/vim/vim.git
repo_git=git@github.com:vim/vim.git # if failed use it to try

# verify input
if [ -z $1 ];then
       echo "input target directory please"
       exit
fi

if [ ! -d $1 ]; then
       echo "directory $1 not exist"
       exit
fi

# get vim repo
for ((i=0; i<$TRY_TIMES; i++)); do
        if [ ! -d $1/$(basename $repo_https .git) ]; then
                echo "get vim from $repo_https"
                if timeout "$MAX_TIME" git clone $repo_https $1/$(basename $repo_https .git); then
                        echo "Git clone successful."
                        break
                fi
        else
                echo "vim already exist in $1"
                break
        fi
done

if [ ! -d $1/$(basename $repo_https .git) ]; then
        echo "get vim from $repo_https failed"
        exit 1
fi

sudo apt remove -y vim
# compile and install vim
cd $1/$(basename $repo_https .git)
sudo make distclean
sudo ./configure  --enable-python3interp --with-python-config-dir=/usr/lib/python3.10/config-3.10-x86_64-linux-gnu/
sudo make && sudo make install
cd -
source $HOME/.bashrc