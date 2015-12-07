#!/bin/bash

passwd='redhat7'
base_dir=~
dir_name=`date +%m%d`
app_base_dir=$base_dir/$dir_name

# Get remote server DNS
tmp_s=`grep -v ^# ~/.openshift/express.conf | grep libra_server | awk -F'=' '{print $2}'`
server_name=`echo ${tmp_s} | sed  "s/'//g"`
# Get user name
tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
user_name=`echo ${tmp_u} | sed  "s/'//g"`

no_scaled_carts='diy-0.1 mock-0.1 mock-0.2 mock-0.3 mock-0.4 jenkins-1'
addon_for_nonscaled_app0="jenkins-client-1 mongodb-2.4 mysql-5.1 postgresql-8.4 phpmyadmin-4 metrics-0.1 rockmongo-1.1 cron-1.4"
addon_for_nonscaled_app1="jenkins-client-1 mongodb-2.4 mysql-5.5 postgresql-9.2 phpmyadmin-4 metrics-0.1 rockmongo-1.1 cron-1.4"
select_addon=0
addon_for_scaled_app0=" mongodb-2.4 mysql-5.1 postgresql-8.4 cron-1.4"
addon_for_scaled_app1=" mongodb-2.4 mysql-5.5 postgresql-9.2 cron-1.4"
for_jbossas_eap="switchyard-0"

function get_webcart()
{
  webcarts=`rhc cartridge list | grep -w web | awk '{print $1}'`
  return $webcarts
}

for webcart in get_webcart
do
app_name=`echo $1 | sed "s/[-.]//g"
sa=$(($select_addon % 2))
echo "create APP-$i"
if [ 0 -eq $sa ]
then
 app_cmd="rhc app create  --no-git
fi
app_cmd="rhc app create  --no-git
echo "create done!"
