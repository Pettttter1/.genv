#!/bin/bash

if [ ! -d $1 ]
then
       mkdir -p $1
fi

cd $1
repos=(https://gitlab.freedesktop.org/wayland/wayland.git
       https://gitlab.freedesktop.org/wayland/wayland-protocols.git
       https://gitlab.freedesktop.org/wayland/weston.git)

for repo in ${repos[@]}
do
        git clone $repo
done

cd -
# for wayland
sudo apt install pkg-config libxml2-dev graphviz doxygen xsltproc xmlto \
ninja-build expat libffi-dev libwayland-dev



