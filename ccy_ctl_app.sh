#!/bin/bash

passwd='redhat'
base_dir=~
dir_name=`date +%m%d`
app_base_dir=$base_dir/$dir_name
apps_cfg=./action_app.cfg

SLEEP_TIME=3

# Get remote server DNS
tmp_s=`grep -v ^# ~/.openshift/express.conf | grep libra_server | awk -F'=' '{print $2}'`
server_name=`echo ${tmp_s} | sed  "s/'//g"`
# Get user's name,password and app's name from parameters
tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
user_name=`echo ${tmp_u} | sed  "s/'//g"`

function write_failed_act
{
  if [ $1 -ne 0 ];
  then
    echo $2 >> ./failed_app_acts.txt
  fi
}

if [ $# -eq 0 ]
then
echo "usage: $0 <appname>"
echo "Set actions by using $apps_cfg file"
exit 1
fi

if [ ! -e $apps_cfg ]
then
echo "Please set actions by using $apps_cfg file"
exit 1
fi

appname=$1
cat /dev/null > ./failed_app_acts.txt
grep -v "^#" ${apps_cfg} > ./fapp_acts.txt

begin_seconds=`date +%s`
cat ./fapp_acts.txt | while read act
do
app_cmd="rhc app $act -a $appname -l $user_name -p $passwd"
echo ${app_cmd}
eval $app_cmd || echo $app_cmd >> ./failed_app_acts.txt
sleep ${SLEEP_TIME}
done
end_seconds=`date +%s`

let cost_snds=${end_seconds}-${begin_seconds}
let cost_mins=${cost_snds}/60
let cost_snd=${cost_snds}%60

if [ ! `cat ./failed_app_acts.txt` ]
then
echo -e "\n\nGood Success! :)"
else
echo -e "\n\nSome Failure. >_<"
fi

echo "Cost Time: ${cost_mins}m(${cost_snd}s)" >> ./failed_app_acts.txt

echo -e "Cost Time: ${cost_mins}m(${cost_snd}s)\n\n"
echo "======================================================="
echo "===========NOTE: Control Application Done!!============"
echo "======================================================="

echo "Failure actions have recorded in ./failed_app_acts.txt"
rm -f ./fapp_acts.txt
