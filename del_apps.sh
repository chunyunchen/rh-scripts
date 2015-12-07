#!/bin/bash

passwd='redhat7'
base_dir=~
dir_name=`date +%m%d`
app_base_dir=$base_dir/$dir_name

SLEEP_TIME=1

# Get server DNS
tmp_s=`grep -v ^# ~/.openshift/express.conf | grep libra_server | awk -F'=' '{print $2}'`
server_name=`echo ${tmp_s} | sed  "s/'//g"`
# Get user name
tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
user_name=`echo ${tmp_u} | sed  "s/'//g"`

if [ $# -eq 1 ]
then
passwd=$1
fi

echo "rhc domain show --server ${server_name} -l ${user_name} -p $passwd"
rhc domain show -l ${user_name} -p $passwd | grep uuid > ./stopped_apps.txt
cat /dev/null > ./failed_stopped.txt

cat ./stopped_apps.txt | while read apps
do
app_name=`echo $apps | cut -d ' ' -f 1`
app_cmd="rhc app delete ${app_name} -l ${user_name} -p $passwd --confirm"
echo "Deleting>> ${app_cmd}"
eval $app_cmd || echo $app_cmd >> ./failed_stopped.txt
sleep $SLEEP_TIME
done

function show_stopped_apps()
{
   echo "------------------Stopped Applications--------------------"
   cat ./stopped_apps.txt
   echo "------------------Stopped Applications--------------------"
}

if [[ ! `cat ./failed_stopped.txt` ]]
then
show_stopped_apps
echo -e "\n=====================\nGood Success! :)\n====================="
rm -f ./failed_stopped.txt 
rm -f ./stopped_apps.txt
else
show_stopped_apps
echo -e "\n=====================Some Failure. >_<\n====================="
echo "Failure actions have been recorded in ./failed_stopped.txt"
fi

