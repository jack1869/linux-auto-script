#!/usr/bin/expect -f
set timeout 1000
set hostport [lindex $argv 0]
set src_file [lindex $argv 1]
set username [lindex $argv 2]
set host [lindex $argv 3]
set dest_file [lindex $argv 4]
set password [lindex $argv 5]
spawn scp -P $hostport $src_file $username@$host:$dest_file
 expect {
 "(yes/no)?"
  {
  send "yes\r"
  expect "*assword:" { send "$password\r"}
 }
 "*assword:"
{
 send "$password\r"
}
}
expect "100%"
expect eof
