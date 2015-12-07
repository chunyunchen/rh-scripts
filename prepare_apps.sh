#!/bin/bash

passwd='redhat7'
base_dir=~
dir_name=`date +%m%d`
app_base_dir=$base_dir/$dir_name

SLEEP_TIME=3 #5 seconds

# Get remote server DNS
tmp_s=`grep -v ^# ~/.openshift/express.conf | grep libra_server | awk -F'=' '{print $2}'`
server_name=`echo ${tmp_s} | sed  "s/'//g"`
# Get user's name,password and app's name from parameters
tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
user_name=`echo ${tmp_u} | sed  "s/'//g"`

function write_failed_app
{
  if [ $1 -ne 0 ];
  then
    echo $2 >> ./failed_apps.txt
  fi
}

cat /dev/null > ./failed_apps.txt

begin_seconds=`date +%s`
while [ $# -ne 0 ]
do
pre_app=`echo $1 | sed "s/[-.]//g"`
echo "Creating non-scalable applications...."
app_cmd=">>> rhc app create c${pre_app} $1  -l $user_name -p $passwd --no-git"
echo ${app_cmd}
rhc app create c${pre_app} $1  -l $user_name -p $passwd --no-git
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app create c${pre_app}jkns $1  -l $user_name -p $passwd --no-git --enable-jenkins"
echo $app_cmd
rhc app create c${pre_app}jkns $1  -l $user_name -p $passwd --no-git --enable-jenkins
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
#app_cmd=">>> rhc app create c${pre_app}stopped $1  -l $user_name -p $passwd --no-git"
echo $app_cmd
rhc app create c${pre_app}stopped $1  -l $user_name -p $passwd --no-git
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app create c${pre_app}idle $1  -l $user_name -p $passwd --no-git"
echo $app_cmd
#rhc app create c${pre_app}idle $1  -l $user_name -p $passwd --no-git
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app create c${pre_app}db $1  -l $user_name -p $passwd --no-git mysql-5.1 mongodb-2.4 postgresql-8.4 rockmongo-1.1 phpmyadmin-4"
echo $app_cmd
rhc app create c${pre_app}db $1  -l $user_name -p $passwd --no-git mysql-5.1 mongodb-2.4 postgresql-8.4 rockmongo-1.1 phpmyadmin-4
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app create c${pre_app}cronmms $1  -l $user_name -p $passwd --no-git cron-1.4 mongodb-2.4 metrics-0.1"
echo $app_cmd
rhc app create c${pre_app}cronmms $1  -l $user_name -p $passwd --no-git cron-1.4 mongodb-2.4 metrics-0.1
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}

echo "Creating scalable applications...."
app_cmd=">>> rhc app create c${pre_app}s $1  -l $user_name -p $passwd --no-git -s"
echo $app_cmd
rhc app create c${pre_app}s $1  -l $user_name -p $passwd --no-git -s
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app create c${pre_app}sjkns $1  -l $user_name -p $passwd --no-git  -s --enable-jenkins"
echo $app_cmd
rhc app create c${pre_app}sjkns $1  -l $user_name -p $passwd --no-git -s --enable-jenkins
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app create c${pre_app}sstopped $1  -l $user_name -p $passwd --no-git -s"
echo $app_cmd
#rhc app create c${pre_app}sstopped $1  -l $user_name -p $passwd --no-git -s
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app create c${pre_app}sidle $1  -l $user_name -p $passwd --no-git -s"
echo $app_cmd
#rhc app create c${pre_app}sidle $1  -l $user_name -p $passwd --no-git -s
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app create c${pre_app}sdb $1  -l $user_name -p $passwd --no-git mysql-5.1 mongodb-2.4 postgresql-8.4 -s"
echo $app_cmd
rhc app create c${pre_app}sdb $1  -l $user_name -p $passwd --no-git mysql-5.1 mongodb-2.4 postgresql-8.4 -s
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}

echo ">>> Stop applications"
app_cmd=">>> rhc app stop c${pre_app}stopped -l $user_name -p $passwd"
echo $app_cmd
rhc app stop c${pre_app}stopped -l $user_name -p $passwd
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
app_cmd=">>> rhc app stop c${pre_app}sstopped -l $user_name -p $passwd"
echo $app_cmd
rhc app stop c${pre_app}sstopped -l $user_name -p $passwd
res=`echo $?`
write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}

shift
done
end_seconds=`date +%s`
let cost_snds=${end_seconds}-${begin_seconds}
let cost_mins=${cost_snds}/60
let cost_snd=${cost_snds}%60

echo "Cost Time: ${cost_mins}m(${cost_snd}s)" >> ./failed_apps.txt

echo -e "\n\nCost Time: ${cost_mins}m(${cost_snd}s)\n\n"
echo "======================================================="
echo "===========NOTE: Idle apps and add MMS cart============"
echo "======================================================="
