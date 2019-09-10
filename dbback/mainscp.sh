#!/bin/bash
bakfile=/alidata/dbbackup/kfsm/tar
cfgfile=/alidata/dbbackup/conf
v_date=$(date '+%Y%m%d%H%M%S')
logfile=/alidata/dbbackup/kfsm/logs/scp_$v_date.log
host_list=$cfgfile/host_list.conf
echo "start scp">>$logfile
date '+%Y-%m-%d %H:%M:%S'>>$logfile
cat $host_list | while read line
do
 host_ip=`echo $line|awk '{print $1}'`
 host_port=`echo $line|awk '{print $2}'`
 username=`echo $line|awk '{print $3}'`
 password=`echo $line|awk '{print $4}'`
 #src_file=`echo $line|awk '{print $5}'`
 dest_file=`echo $line|awk '{print $5}'`
 ##key=`echo $line|awk '{print $7}'`
 ##./remotescp.sh $key $src_file $username $host_ip $dest_file $password
 #./remotescp.sh $host_port $src_file $username $host_ip $dest_file $password
 tarfile=`find $bakfile/ -name "*.tar.gz" -type f -ctime -1 |sort -r`
 #echo ${tarfile}
 t=`echo ${tarfile} |awk -F " " '{print $1}'`
 #echo $host_ip
 #echo $t
 #echo $username
 echo $host_port $t $username@$host_ip:$dest_file
 /alidata/dbbackup/remotescp.sh $host_port $t $username $host_ip $dest_file $password
done
echo "end scp">>$logfile
date '+%Y-%m-%d %H:%M:%S'>>$logfile
