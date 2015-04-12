#!/bin/bash 

[ $# -eq 2 ] || exit 1

ONE=`echo $1 | rev | cut -f 1 -d '/' | rev`
TWO=`echo $2 | rev | cut -f 1 -d '/' | rev`
pid=$$
rand1=/tmp/tmp.${pid}.$RANDOM.$ONE
rand2=/tmp/tmp.${pid}.$RANDOM.$TWO
hexdump -C -v $1 > $rand1
hexdump -C -v $2 > $rand2

vimdiff $rand1 $rand2



