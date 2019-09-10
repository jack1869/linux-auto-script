#!/bin/sh
set conffile [lindex $argv 0]
#set ifremote [lindex $argv 1]

pathbase=/root/autocp
v_date=$(date '+%Y%m%d%H%M%S')
filelist=${pathbase}/conf/$conffile
logfile=${pathbase}/logs/${conffile%%.*}.log

echo 'begin a server...'
cat $filelist | while read line
do
 srcpath=`echo $line|awk '{print $1}'`
 destpath=`echo $line|awk '{print $2}'`
 destpathup=${destpath%/*}
 destbak=${destpathup%/*}
 srcfile=${srcpath##*/}
 destfile=${destpath}${srcfile}
 if [ ! -d "${destbak}/backup/${v_date}" ]; then
  mkdir -p ${destbak}/backup/${v_date}
 else
  echo ${destbak}/backup/${v_date}
 fi
 if [ ! -f "$destfile" ]; then
  echo ${destfile} not exists!
 else
  cp ${destfile} ${destbak}/backup/${v_date}/
 fi
 
done
echo 'local success!'
