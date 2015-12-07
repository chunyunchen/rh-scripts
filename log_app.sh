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
  app_ssh_url=`rhc app show -a $app_name -l$user_name -p$passwd | grep SSH | awk '{print $2}'`
  if [ "$app_ssh_url" == "" ]
  then
    echo ">>>>>>>>>>>"
    echo "There is not app '$app_name' on $user_name"
    echo "Please enter the correct app name at the first position of the script's parameters."
    echo "<<<<<<<<<<<"
    exit 1
  fi
  echo ">>>>>>>>>>>"
  echo "app name: $app_name"
  echo "user name: $user_name"
  echo "password: $passwd"
  echo "<<<<<<<<<<<"
  ssh $app_ssh_url
# Not giving the app, show the domain
else
  echo ">>>>>>>>>>>"
  echo "Show ${user_name}'s app(s)...."
  echo -e "password: $passwd"
  echo "<<<<<<<<<<<"
  rhc domain show -l ${user_name} -p ${passwd}

fi
