#!/bin/bash

passwd='redhat7'
base_dir=~/.openshift
dir_name=`date +%m%d`
app_base_dir=$base_dir/$dir_name


# Get user's name,password and app's name from parameters
tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
user_name=`echo ${tmp_u} | sed  "s/'//g"`
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
  else
    app_name=$1
    shift
  fi
done

function del_expect()
{
cat > ./delExp.exp << END 
#!/usr/bin/expect -f
spawn rhc app delete $app_name -l$user_name -p$passwd
expect "*(yes|no)*"
send "yes\r"
send "exit\r"
expect eof
interact
END

chmod 700 ./delExp.exp
/usr/bin/expect ./delExp.exp
rm -rf $app_base_dir/$app_name
}

# If giving the app, ssh into the app's instance
if [ ! "$app_name" == "" ]
then
  echo ">>>>>>>>>>>"
  echo "app name: $app_name"
  echo "user name: $user_name"
  echo "password: $passwd"
  echo "<<<<<<<<<<<"
  echo "APP Name: $app_name"
  del_expect
# Not giving the app, show the domain
else
  app_names=`rhc domain show -l$user_name -p$passwd | grep @ | grep -w http | awk '{print $1}'`
  echo ">>>>>>>>>>>"
  echo "Delete ${user_name}'s app(s)...."
  echo -e "password: $passwd"
  echo "<<<<<<<<<<<"
  for app_name in $app_names
  do
    echo "del APP Name: $app_name"
    del_expect
  done

fi

rm -rf ./delExp.exp
