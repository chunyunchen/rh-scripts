#!/bin/bash

passwd='redhat7'
base_dir=~
dir_name=`date +%m%d`
app_base_dir=$base_dir/$dir_name
apps_cfg=./apps.cfg
domain_name=cintos2

SLEEP_TIME=3

# Get server DNS
tmp_s=`grep -v ^# ~/.openshift/express.conf | grep libra_server | awk -F'=' '{print $2}'`
server_name=`echo ${tmp_s} | sed  "s/'//g"`
# Get user name
tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
user_name=`echo ${tmp_u} | sed  "s/'//g"`

if [[ ! -e $apps_cfg ]]
then
echo "Please set actions by using $apps_cfg file"
exit 1
fi

function write_failed_app
{
  if [[ $1 -ne 0 ]];
  then
    echo $2 >> ./failed_apps.txt
  fi
}

cat /dev/null  > ./failed_apps.txt

grep -v "^#" ${apps_cfg} > ./fapps.txt

begin_seconds=`date +%s`
while [ $# -ne 0 ]
do
pre_app=`echo $1 | sed "s/[-.]//g"`
cat ./fapps.txt | while read apps
do
one_side_app=`echo $apps | cut -d ' ' -f 1`
if [[ "${one_side_app}" == "ONS" ]]
then 
suffix_app_name=`echo $apps | cut -d ' ' -f 2`
create_params=`echo $apps | cut -d ' ' -f 3-`
app_cmd="rhc app create c${pre_app}${suffix_app_name} $1  -l $user_name --no-git ${create_params} -g medium"
echo ${app_cmd}
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
if [[ `echo "${suffix_app_name}" | grep "stopped"` ]]
then
echo ">>> Stop applications"
app_cmd="rhc app stop c${pre_app}${suffix_app_name} -l $user_name"
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
fi
continue
fi

if [[ "${one_side_app}" == "OS" ]]
then
suffix_app_name=`echo $apps | cut -d ' ' -f 2`
create_params=`echo $apps | cut -d ' ' -f 3-`
app_cmd="rhc app create c${pre_app}s${suffix_app_name} $1  -l $user_name --no-git -s ${create_params} -g medium"
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
if [[ `echo "${suffix_app_name}" | grep "stopped"` ]]
then
echo ">>> Stop application"
app_cmd="rhc app stop c${pre_app}s${suffix_app_name} -l $user_name"
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
fi
if [[ `echo "${suffix_app_name}" | grep "multigears"` ]]
then
echo ">>> Scale up application"
app_cmd='curl -k -H "Accept: application/xml" --user "$user_name:$passwd" https://$server_name/broker/rest/domains/$domain_name/applications/c${pre_app}s${suffix_app_name}/events -d event=scale-up -X POST'
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
fi
if [[ `echo "${suffix_app_name}" | grep "min2gears"` ]]
then
echo ">>> Set 2 min gears for application"
app_cmd="rhc cartridge scale $1 -a c${pre_app}s${suffix_app_name} -l $user_name --min 2 --max -1"
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
fi
continue
fi

suffix_app_name=`echo $apps | cut -d ' ' -f 1`
create_params=`echo $apps | cut -d ' ' -f 2-`
if [[ "${suffix_app_name}" == "${create_params}" ]]
then
  create_params=''
fi
app_cmd="rhc app create c${pre_app}${suffix_app_name} $1  -l $user_name -p $passwd --no-git ${create_params}  -g medium"
echo ${app_cmd}
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}

app_cmd="rhc app create c${pre_app}s${suffix_app_name} $1  -l $user_name -p $passwd --no-git -s ${create_params}  -g medium"
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}

if [[ `echo "${suffix_app_name}" | grep "stopped"` ]]
then
echo ">>> Stop application"
app_cmd="rhc app stop c${pre_app}${suffix_app_name} -l $user_name -p $passwd"
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
app_cmd="rhc app stop c${pre_app}s${suffix_app_name} -l $user_name -p $passwd"
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
#res=`echo $?`
#write_failed_app $res "${app_cmd}"
sleep ${SLEEP_TIME}
fi
if [[ `echo "${suffix_app_name}" | grep "multigears"` ]]
then
echo ">>> Scale up application"
app_cmd='curl -k -H "Accept: application/xml" --user "$user_name:$passwd" https://$server_name/broker/rest/domains/$domain_name/applications/c${pre_app}s${suffix_app_name}/events -d event=scale-up -X POST'
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
fi
if [[ `echo "${suffix_app_name}" | grep "min2gears"` ]]
then
echo ">>> Set 2 min gears for application"
app_cmd="rhc cartridge scale $1 -a c${pre_app}s${suffix_app_name} -l $user_name --min 2 --max -1"
echo $app_cmd
eval $app_cmd || echo $app_cmd >> ./failed_apps.txt
sleep ${SLEEP_TIME}
fi


done

shift
done

end_seconds=`date +%s`
let cost_snds=${end_seconds}-${begin_seconds}
let cost_mins=${cost_snds}/60
let cost_snd=${cost_snds}%60

if [[ ! `cat ./failed_apps.txt` ]]
then
echo -e "\n\nGood Success! :)"
else
echo -e "\n\nSome Failure. >_<"
fi

echo "Cost Time: ${cost_mins}m(${cost_snd}s)" >> ./failed_apps.txt
echo "==Server: ${server_name} | User: ${user_name}=="  >> ./failed_apps.txt

echo -e "Cost Time: ${cost_mins}m(${cost_snd}s)\n\n"
echo "Server: ${server_name} | User: ${user_name}"
echo "========================================================================"
echo "=NOTE: Idle app | add MMS cart | Scale up | Quick Start | Set Min Gears="
echo "========================================================================"

echo "Failure actions have been recorded in ./failed_apps.txt"
echo "--------------------------------------------------------"
echo "--------------------------------------------------------"
rm -f ./fapps.txt
