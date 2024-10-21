#!/bin/bash

CUR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
files=(
        util.sh
        git.sh
)
for file in ${files[@]}
do
        source "$CUR/$file"
done