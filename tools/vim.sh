#!/bin/bash

# vaild input
if [ -z $1 ];then
       echo "input target directory please"
       exit
fi

if [ ! -d $1 ]; then
       echo "directory $1 not exist"
       exit
fi
MAX_TIME=30  # Adjust this value as needed
# get vim repo
sudo apt remove -y vim # remove old vim
repo_https=https://github.com/vim/vim.git
repo_git=git@github.com:vim/vim.git

if [ ! -d $1/$(basename $repo_https .git) ]; then
        echo "get vim from $repo_https"
        if timeout "$MAX_TIME" git clone $repo_https $1/$(basename $repo_https .git); then
                echo "Git clone successful."
        else
                if [ $? -eq 124 ]; then
                        echo "Git clone failed: Operation timed out after ${MAX_TIME} seconds."
                else
                        echo "use https failed, try use git"
                        git clone $repo_git $1/$(basename $repo_git .git)
                fi

                if [ ! $? -eq 0 ]; then
                        echo "git clone failed"
                        exit 1
                fi
        fi
else
        echo "vim already exist in $1"
fi
# compile and install vim
cd $1/$(basename $repo_https .git)
sudo make distclean
sudo ./configure  --enable-python3interp --with-python-config-dir=/usr/lib/python3.10/config-3.10-x86_64-linux-gnu/
sudo make && sudo make install
cd -