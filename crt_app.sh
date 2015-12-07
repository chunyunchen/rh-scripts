#!/bin/bash

passwd='redhat'
base_dir=~
dir_name=`date +%m%d`
app_base_dir=$base_dir/$dir_name

# Get remote server DNS
tmp_s=`grep -v ^# ~/.openshift/express.conf | grep libra_server | awk -F'=' '{print $2}'`
server_name=`echo ${tmp_s} | sed  "s/'//g"`
# Get user's name,password and app's name from parameters
tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
user_name=`echo ${tmp_u} | sed  "s/'//g"`

echo "Do you .."
echo "Create a domain with \"rhc setup | rhc domain create\" against ${server_name}?"
echo "Set max gears with \"oo-admin-ctl-user -l $user_name --setmaxgears 100\"?"
echo -n "[y/n] "
read y_n
if [ "${y_n}" == "n" ]
then
  exit 0
fi

if [ ! -d $base_dir/$dir_name ]
then
  mkdir -p $base_dir/$dir_name
fi

while [ $# -ne 0 ]
do
  if [ "$1" == "-l" ]
  then
    user_name=$2
    shift
    shift
  elif [ "$1" == "-p" ]
  then
    passwd=$2
    shift
    shift
  elif [ "$1" == "-s" ]
  then
    scalable=$1
    shift
  else
    all_app_cartridges+=" $1"
    shift
  fi
done

num=`echo $user_name | sed "s/[^0-9]//g"`
user_num=0
if [ "$num" != "" ]
then
  user_num=$num
fi
#all_app_names=`rhc cartridge list | grep -w Y | awk '{print $1}' | sed "s/[-\.0-9]//g"`
if [ "$all_app_cartridges" == "" ]
then
all_app_cartridges=`rhc cartridge list | grep -w web | awk '{print $1}'`
fi

echo ">>>>>>>>>>>"
echo "user name: $user_name"
echo "password: $passwd"
echo "<<<<<<<<<<<"

function do_expect()
{
cat > ./doExp.exp << END 
#!/usr/bin/expect -f
spawn rhc app create ${app_name} $cart_type  ${scalable} -l $user_name -p $passwd -r $app_base_dir/$app_name
sleep 15
expect "*(yes/no)?*"
send "yes\r"
sleep 15
expect "*(yes/no)?*"
send "yes\r"
send "exit\r"
expect eof
interact
END

chmod 700 ./doExp.exp
/usr/bin/expect ./doExp.exp
}

for cart_type in $all_app_cartridges
do
  app_num=0
  app_name_prefix=`echo $cart_type | sed "s/[-\.0-9]//g"`  
  name_scale=`echo $scalable | sed "s/-//g"`
  app_name=${app_name_prefix}${user_num}${name_scale}${app_num}
  while [ -d $app_base_dir/$app_name ]
  do
    app_num=`expr $app_num + 1`
    app_name=${app_name_prefix}${user_num}${name_scale}${app_num}
  done
  do_expect
done

rm -rf ./doExp.exp
