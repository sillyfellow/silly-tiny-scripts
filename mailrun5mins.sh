#!/bin/bash

# # first do some imapfiltering, then get the mails
# LOGFILE="/home/sands/.imapfilter/imapfilter.log"
# echo "Now the time is $(date)" >> $LOGFILE
# result=`pgrep imapfilter`
# 
# if [ $result ]
# then
#         echo "imapfilter is already running" >> $LOGFILE
# else
# #         echo "imapfilter is not running" >> $LOGFILE
# #         echo "Starting imapfilter...." >> $LOGFILE
# #         /usr/bin/imapfilter -l $LOGFILE 
# fi


# now, let's pull the emails.
PID=$(pgrep offlineimap)
LOGFILE=$HOME/.offlineimap/runlogs.log

[[ -n "$PID" ]] && kill "$PID" && echo "Killed the earlier one" >> $LOGFILE

echo "Starting new at $(date)" >> $LOGFILE
offlineimap -o -u quiet &>/dev/null &

exit
