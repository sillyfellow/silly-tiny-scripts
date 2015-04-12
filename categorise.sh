#!/bin/bash - 
#===============================================================================
#
#          FILE: categorise.sh
# 
#         USAGE: ./categorise.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Dr. Sandeep Sadanandan (sillyfellow), grep@whybenormal.org
#  ORGANIZATION: Galactic Sector ZZ9 Plural Z Alpha
#       CREATED: 04/12/2015 12:48
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

TEMPFILE=$(mktemp)
grep -v -f finished.txt tobedone.txt | shuf > ${TEMPFILE}

while read song 
do
  mpg123 "$song"
  echo "How is the song?"
  echo "1 - excellent"
  echo "2 - good"
  echo "3 - okay"
  echo "4 - won't listen"
  echo "5 - throw away"
  read QUALITY < /dev/tty 
  echo "What is its character?"
  echo "1 - energy"
  echo "2 - melody"
  echo "3 - sad (good)"
  echo "4 - classic"
  echo "5 - semiclassic"
  echo "6 - general"
  echo "7 - who cares?"
  read CHARACTER < /dev/tty 
  echo "$song" >> ${QUALITY}${CHARACTER}.txt 
  echo "$song" >> finished 
done  < ${TEMPFILE}

