#!/bin/bash 

find . -type f | grep png > /tmp/all_pngs

while read file 
do
  md5 -r "$file"
done < /tmp/all_pngs > /tmp/all_md5_sums

sort /tmp/all_md5_sums | tee /tmp/wholelist | cut -f 1,2 -d ' ' | uniq -d > /tmp/csum.tmp ; grep -hif /tmp/csum.tmp /tmp/wholelist
