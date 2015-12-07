#!/bin/bash

for ((port=1025; port<65536; port++))
do
curl portquiz.net:$port > ./port_res.txt
curl portquiz.net:$port >> ./port_results.txt
if [ `grep successful ./port_res.txt` ]
then
  echo $port >> ./safe_ports.txt
  continue
fi
echo $port >> ./non_safe_ports.txt
done

rm -f ./port_res.txt
