#!/bin/bash

passwd='redhat'
base_dir=~
dir_name=`date +%m%d`
app_base_dir=$base_dir/$dir_name

SLEEP_TIME=1

if [ $# -lt 1 ]
then
echo -e "\nPlease input action or 'all', like: stop/start/force-stop/restart/reload/git-clone"
exit 0
fi

# Get server DNS
tmp_s=`grep -v ^# ~/.openshift/express.conf | grep libra_server | awk -F'=' '{print $2}'`
server_name=`echo ${tmp_s} | sed  "s/'//g"`
# Get user name
#tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
#user_name=`echo ${tmp_u} | sed  "s/'//g"`
user_name=$(rhc account | grep -i login | awk '{print $2}')
domain_name=$(rhc domains | grep -i "owned by" | awk '{print $2}')

apps=""
actions="show"  # default action
get_apps_from_command_line ()
{
cat /dev/null > ./failed_ctl.txt
while [ "$#" != "0" ]
do
  case "$1" in 
    "all" )
#      actions="force-stop restart stop start reload"
      actions="force-stop restart stop start reload git-clone"
      shift
      ;;
    "-p" )
      shift
      passwd=$1
      shift
      ;;
    "-a" )
      shift
      apps=$@
      shift $#
      ;;
    * )
      actions=$1
      shift
      ;;
  esac
done
}

run_cmd ()
{
  app_cmd="rhc app $act ${app_name} -l ${user_name} -p $passwd"
  case $act in
     "show" )
       app_cmd="$app_cmd --gears"
       echo $app_cmd && eval $app_cmd || echo $app_cmd >> ./failed_ctl.txt
      ;;
     "git-clone" )
       app_cmd="rhc $act ${app_name} -r ~/test/daily/${app_name}"
       echo $app_cmd && eval $app_cmd || echo $app_cmd >> ./failed_ctl.txt 
      ;;
     "delete" )
       app_cmd="$app_cmd --confirm"
       echo $app_cmd && eval $app_cmd || echo $app_cmd >> ./failed_ctl.txt
      ;;
     "snapshot" )
        save_app_cmd="rhc $act save ${app_name} -l ${user_name} -p $passwd"
        restore_app_cmd="rhc $act restore ${app_name} -l ${user_name} -p $passwd"
        echo $save_app_cmd && eval $save_app_cmd || echo $save_app_cmd >> ./failed_ctl.txt 
        echo $restore_app_cmd && eval $restore_app_cmd || echo $restore_app_cmd >> ./failed_ctl.txt
      ;;
     * )
       echo $app_cmd && eval $app_cmd || echo $app_cmd >> ./failed_ctl.txt
      ;;
  esac
}

app_file="/dev/null"
get_apps ()
{
  echo "rhc domain show --server ${server_name} -l ${user_name} -p $passwd"
  rhc domain show -l ${user_name} -p $passwd | grep uuid > ./ctl_apps.txt
  cat /dev/null > ./failed_ctl.txt
  app_file="./ctl_apps.txt"
}

show_head_prompt ()
{
  [[ -z $apps ]] && head_prompt="\n Control all of apps in current domain(\"$domain_name\") \n" || head_prompt="\n Get apps from command line \n"
  [[ -z "$1" ]] && char_prompt="*" || char_prompt=$1 ## default prompt char
  char_count=${#head_prompt}
  prompt="$char_prompt"
  while [ "$char_count" != "0" ]
  do
    prompt=${prompt}${char_prompt}
    char_count=$(($char_count-1)) 
  done
  echo -e "${prompt}${head_prompt}${prompt}"
}

get_apps_from_command_line $@
show_head_prompt
[[ -z $apps ]] && get_apps

for app_name in $apps
do
  for act in $(echo $actions)
    do
      run_cmd
      echo ""
      sleep $SLEEP_TIME
    done
done

cat $app_file | while read app
do
app_name=$(echo $app | cut -d ' ' -f 1)
  for act in $(echo $actions)
    do
      run_cmd
      echo ""
      sleep $SLEEP_TIME
    done
done

function show_ctl_apps()
{
   echo "------------------Applications--------------------"
   cat ./ctl_apps.txt
   echo "------------------Applications--------------------"
}

if [[ ! `cat ./failed_ctl.txt > /dev/null` ]]
then
[[ -z $apps ]] && show_ctl_apps
echo -e "\n=====================\n\033[32;49;1mGood Success! :)\033[39;49;0m\n=====================\n"
rm -f ./failed_ctl.txt 
rm -f ./ctl_apps.txt
else
[[ -z $apps ]] && show_ctl_apps
echo -e "\n=====================\n\033[31;49;1mFailure!!! >_<\033[39;49;0m\n====================="
echo -e "\033[31;49;1mFail actions have been recorded in ./failed_ctl.txt\033[39;49;0m\n"
fi

