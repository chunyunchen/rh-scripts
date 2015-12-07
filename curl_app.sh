#!/bin/bash

passwd='redhat_123'

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
  elif [ "$1" == "-hp" ]
  then
    end_http=$2
    shift
    shift
  elif [ "$1" == "-dn" ]
  then
    domain=$2
    shift
    shift
  elif [ "$1" == "-a" ]
  then
    appname=$2
    shift
    shift
  elif [ "$1" == "-h" ]
  then
    instance_name==$2
    shift
    shift
  else
    all_app_cartridges+=" $1"
    shift
  fi
done


if [ "$instance_name" == "" ]
then
  tmp=`grep -v ^# ~/.openshift/express.conf |grep  libra_server | awk -F'=' '{print $2}'`
  instance_name=`echo ${tmp} | sed  "s/'//g"`
fi

if [ ! "$instance_name" == "" ]
then
  echo ">>>>>>>>>"
  echo "instance name: $instance_name"
  echo "login user name: $user_name"
  echo "password: $passwd"
  echo "<<<<<<<<<"
#  ssh -i ~/libra-new.pem $user_name@$instance_name
else
  echo "Please enter your instance name."
  echo "eg: $0 <instance_name>"
fi


echo "curl -k -H \"Accept: application/xml\" --user \"$user_name:$passwd\" https://${instance_name}/broker/rest/domains/$domain/applications/$appname/$end_http/  -X GET"

