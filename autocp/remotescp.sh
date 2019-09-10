#!/usr/bin/expect -f
set timeout 1000
set srcfile [lindex $argv 0]
set host_ip [lindex $argv 1]
set passwd [lindex $argv 2]
set destfile [lindex $argv 3]

spawn scp -P 22 $srcfile root@${host_ip}:$destfile
 expect {
 "(yes/no)?"
  {
  send "yes\r"
  expect "*assword:" { send "$passwd\r"}
 }
 "*assword:"
{
 send "$passwd\r"
}
}
expect "100%"
expect eof
