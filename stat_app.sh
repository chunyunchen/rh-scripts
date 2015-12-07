#!/bin/bash

passwd='redhat'

# In default condition, show the domain
#if [ $# -eq 0 ]
#then
#  echo -e "Show ${user_name}'s app(s)....\n"
#  rhc domain show -l$user_name -p$passwd
#fi

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

# If giving the app, ssh into the app's instance
if [ ! "$app_name" == "" ]
then
  echo ">>>>>>>>>>>"
  echo "app name: $app_name"
  echo "user name: $user_name"
  echo "password: $passwd"
  echo "<<<<<<<<<<<"
  echo "APP Name: $app_name"
  rhc app show $app_name --state -l$user_name -p$passwd
# Not giving the app, show the domain
else
  app_names=`rhc domain show -l$user_name -p$passwd | grep @ | grep -w http | awk '{print $1}'`
  echo ">>>>>>>>>>>"
  echo "Show ${user_name}'s app(s)'s status...."
  echo -e "password: $passwd"
  echo "<<<<<<<<<<<"
  for p_name in $app_names
  do
    echo "APP Name: $p_name"
    rhc app show $p_name --state -l$user_name -p$passwd
    echo -e "\n"
  done

fi
