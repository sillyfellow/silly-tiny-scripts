#!/bin/bash 

set -x 

git reset -- $1
git checkout -- $1
