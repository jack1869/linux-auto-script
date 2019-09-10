#! /sbin/bash
presult=`ping -c 2  171.13.38.211|grep 'ttl'|wc -l`
if [ ${presult} -gt 0 ]; then
 echo "ping ok"
 tresult=`(sleep 2;)|telnet 171.13.38.211 8809|grep '\^]'|wc -l`
 if [ ${tresult} -gt 0 ]; then
  echo "telnet ok"
  date '+%Y-%m-%d %H:%M:%S'
  . /alidata/dbbackup/b.sh
  echo 'begin sh'
  date '+%Y-%m-%d %H:%M:%S'
 else
  echo "telnet false"
 fi
else
 echo "ping false"
fi

