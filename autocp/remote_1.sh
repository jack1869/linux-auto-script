#!/bin/bash

#./main.sh a.conf
base=/root/autocp
curhost=$base/conf/host.conf
confpath=$base/conf

cat $curhost | while read line
do
 hostip=`echo $line|awk '{print $1}'`
 password=`echo $line|awk '{print $2}'`
 copyconf=`echo $line|awk '{print $3}'`
 copyconff=${confpath}/$copyconf
 cat $copyconff | while read line
 do
  srcpath=`echo $line|awk '{print $1}'`
  backpath=`echo $line|awk '{print $2}'`
  destpath=`echo $line|awk '{print $3}'`
  srcfile=${srcpath##*/}
  echo $backpath/$srcfile $destpath >> $base/rfile/${copyconf%%.*}_r.conf
  #./remotescp $srcpath $hostip $password $backpath
 done
done
echo 'scp remote success!'
