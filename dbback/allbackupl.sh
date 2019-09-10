#!/bin/bash

cfgfile=/alidata/dbbackup/conf
user_list=${cfgfile}/user_list.conf
bakbase=/alidata/dbbackup/allbak
#pafiles=/alidata/dbbackup/conf/tables.cfg

v_date=$(date '+%Y%m%d%H%M%S')
cat $user_list | while read line
do
 username=`echo $line|awk '{print $1}'`
 password=`echo $line|awk '{print $2}'`
 usid=`echo $line|awk '{print $3}'`
 #password=`echo $line|awk '{print $4}'`

 #tarfile=`find $bakfile/ -name "*.tar.gz" -type f -ctime -1 |sort -r`
 #echo ${tarfile}
 #t=`echo ${tarfile} |awk -F " " '{print $1}'`
 #echo $host_ip
 #echo $t
 #echo $username
 #echo $host_port $t $username@$host_ip:$dest_file
 userbase=${bakbase}/${username}
 if [ ! -d "${bakbase}/${username}" ]; then
  mkdir -p ${userbase}/tar
  mkdir -p ${userbase}/logs
  mkdir -p ${userbase}/dmp
  chown oracle:oinstall ${userbase}/dmp
 fi
 v_date=$(date '+%Y%m%d%H%M%S')
 logfile=${userbase}/logs/${username}_backup_${v_date}.log

 su oracle -lc "export NLS_LANG='SIMPLIFIED CHINESE_CHINA.ZHS16GBK'
 exp ${username}/${password}@${usid} file=${userbase}/dmp/${username}_${v_date}.dmp log=${userbase}/dmp/${username}_${v_date}.log buffer=5000000 compress=n"
 #exp ${username}/${password}@${usid} file=${userbase}/dmp/${username}_${v_date}.dmp log=${userbase}/dmp/${username}_${v_date}.log buffer=5000000 compress=n parfile=${pafiles}
 echo "end_time">>${logfile}
 date '+%Y-%m-%d %H:%M:%S'>>${logfile}
 echo "express file begin">>${logfile}
 if [ -f "${userbase}/dmp/${username}_${v_date}.dmp" ]; then
  echo "start tar files">>${logfile}
  cd ${userbase}/dmp/
  date '+%Y-%m-%d %H:%M:%S'>>${logfile}
  tar -zcvf ${userbase}/tar/${username}_${v_date}.dmp.tar.gz ${username}_${v_date}.* && rm -f ${userbase}/dmp/${username}_${v_date}.*

  echo "start delete tar.gz history">>${logfile}
  date '+%Y-%m-%d %H:%M:%S'>>${logfile}
  ls ${userbase}/tar/${username}_*.dmp.tar.gz >>${logfile}
  find ${userbase}/tar -name "${username}_*.dmp.tar.gz" -mtime +2 -exec rm {} \;
  find ${userbase}/logs -name "${username}_*.log" -mtime +3 -exec rm {} \;
 fi 
 sleep 10s
done
