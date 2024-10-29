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

# get vim repo
sudo apt remove -y vim # remove old vim
repo_https=https://github.com/vim/vim.git
repo_git=git@github.com:vim/vim.git
git clone $repo_https $1/$(basename $repo_https .git)
if [ ! $? -eq 0 ]; then
        echo "use https failed, try use git"
        git clone $repo_git $1/$(basename $repo_git .git)
fi

if [ ! $? -eq 0 ]; then
        echo "git clone failed"
        exit
fi

# compile and install vim
cd $1/$(basename $repo .git)
sudo make distclean
sudo ./configure  --enable-python3interp --with-python-config-dir=/usr/lib/python3.10/config-3.10-x86_64-linux-gnu/
sudo make && sudo make install
cd -