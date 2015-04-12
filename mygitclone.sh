#!/bin/bash

# create argument count check

set -x 

repofullname=$1
username=$(echo $repofullname | cut -f 1 -d '/')
reponame=$(echo $repofullname | cut -f 2 -d '/')
diskloca=~/github.com/${username}
ghubloca=git://github.com/${repofullname}

echo $diskloca
echo $ghubloca

mkdir -p ${diskloca} && cd ${diskloca} && git clone ${ghubloca} && cd ${reponame} && pullallbranches

