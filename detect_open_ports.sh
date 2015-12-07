#!/bin/bash

echo "Please wait to DONE...(the last port is 65535)"
netstat -nap | grep -w tcp > tcp_ports.txt
for ((port=1024; port<65536; port++))
do
  cur_5000=$(($port%5000))
  if [ $cur_5000 -eq 0 ]
  then
    echo "Current port at $port"
  fi
  curl portquiz.net:$port &>ccyres.txt
  if [ -z "`grep successful ccyres.txt`"  -a "`grep -w $port tcp_ports.txt`" ]
  then
    echo "curl portquiz.net:$port"
    echo "Detect as FAILED!"
    exit 0
  fi
done
rm -f ccyres.txt tcp_ports.txt
echo "Detect SUCCESS!"
echo "DONE"
