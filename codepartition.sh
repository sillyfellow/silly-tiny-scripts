#!/bin/bash 

USAGE="Usage: $0 <mount|umount>"

[ ! $# -eq 1 ] && echo "$USAGE" && exit

if [ $1 = "mount" ] 
then 
  df | grep 'code' > /dev/null && echo "Already mounted" && exit 0
  sudo cryptsetup luksOpen /dev/sda3 sda3
  sudo mount /dev/mapper/sda3 /home/sands/go/src 
elif [ $1 = "umount" ]
then 
  sudo umount /dev/mapper/sda3 && sudo cryptsetup luksClose sda3
else 
  echo $USAGE 
fi 

