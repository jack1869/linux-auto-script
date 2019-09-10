#!/bin/bash
#backup.sh

bakpath=/alidata/dbbackup/kfsm
pafiles=/alidata/dbbackup/conf/tables.cfg
v_date=$(date '+%Y%m%d%H%M%S')
logfile=$bakpath/logs/kfsm_backup_$v_date.log
echo backup_time>>$logfile
date '+%Y-%m-%d %H:%M:%S' >> $logfile
echo "backup kfsmdb">>$logfile
echo "start_time">>$logfile
date '+%Y-%m-%d %H:%M:%S' >> $logfile
ORACLE_HOME=/alidata/oracle/product/10.2.0
v_date=$(date '+%Y%m%d%H%M%S')
su oracle -lc "export NLS_LANG='SIMPLIFIED CHINESE_CHINA.ZHS16GBK'
	       exp kfsmcard/byc95304267@pri_byc1001 file=${bakpath}/dmp/kfsm_${v_date}.dmp log=${bakpath}/dmp/kfsm_${v_date}.log buffer=5000000 compress=n parfile=${pafiles}"
echo "end_time">>$logfile
date '+%Y-%m-%d %H:%M:%S'>>$logfile
echo "express file begin">>$logfile
if [ -f "${bakpath}/dmp/kfsm_${v_date}.dmp" ]; then
echo "start tar files">>$logfile
cd ${bakpath}/dmp/
date '+%Y-%m-%d %H:%M:%S'>>$logfile
tar -zcf ${bakpath}/tar/kfsm_${v_date}.dmp.tar.gz kfsm_${v_date}.* && rm -f ${bakpath}/dmp/kfsm_${v_date}.*

echo "start delete tar.gz history">>$logfile
date '+%Y-%m-%d %H:%M:%S'>>$logfile
ls $bakpath/tar/kfsm_*.dmp.tar.gz >>$logfile
find $bakpath/tar -name "kfsm_*.dmp.tar.gz" -mtime +2 -exec rm {} \;
find $bakpath/logs -name "kfsm_*.log" -mtime +5 -exec rm {}  \;
fi

echo "start all back">>$logfile
/alidata/dbbackup/allbackupl.sh

date '+%Y-%m-%d %H:%M:%S'>>$logfile
echo "end allbackup">>$logfile
date '+%Y-%m-%d %H:%M:%S'>>$logfile

#start scp
echo "start scp">>$logfile

presult=`ping -c 2  171.13.38.211|grep 'ttl'|wc -l`
if [ ${presult} -gt 0 ]; then
 echo "ping ok">>$logfile
 tresult=`(sleep 5;)|telnet 171.13.38.211 8809|grep '\^]'|wc -l`
 if [ ${tresult} -gt 0 ]; then
  echo "telnet ok">>$logfile
  date '+%Y-%m-%d %H:%M:%S'>>$logfile

 else
  echo "telnet false">>$logfile
 fi
else
 echo "ping false">>$logfile
fi

date '+%Y-%m-%d %H:%M:%S'>>$logfile
echo "end scp">>$logfile


