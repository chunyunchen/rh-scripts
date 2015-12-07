#!/bin/bash

passwd='redhat7'
base_dir=~

# Get remote server DNS
tmp_s=`grep -v ^# ~/.openshift/express.conf | grep libra_server | awk -F'=' '{print $2}'`
server_name=`echo ${tmp_s} | sed  "s/'//g"`
# Get user's name,password and app's name from parameters
#tmp_u=`grep -v ^# ~/.openshift/express.conf |grep  default_rhlogin | awk -F'=' '{print $2}'`
#user_name=`echo ${tmp_u} | sed  "s/'//g"`
user_name=`rhc account | grep -i login | awk '{print $2}'`

domain_name=$1
app_name=$2

if [ $# -ge 2 ]
then
  echo "*****Scale-UP App CURL Path*****"
  echo "curl -k -H \"Accept: application/xml\" --user \"${user_name}:$passwd\" https://${server_name}/broker/rest/domains/${domain_name}/applications/${app_name}/events -d event=scale-up -X POST"
  echo "*****GearGroup CURL Path*****"
  echo "curl -k -H \"Accept: application/xml\" --user \"${user_name}:$passwd\" https://${server_name}/broker/rest/domains/${domain_name}/applications/${app_name}/gear_groups -X GET"
  echo "*****Scale-DOWN App CURL Path*****"
  echo "curl -k -H \"Accept: application/xml\" --user \"${user_name}:$passwd\" https://${server_name}/broker/rest/domains/${domain_name}/applications/${app_name}/events -d event=scale-down -X POST"
  echo "*****Application CURL Path*****"
  echo "curl -k -H \"Accept: application/xml\" --user \"${user_name}:$passwd\" https://${server_name}/broker/rest/domains/${domain_name}/applications/${app_name} -X GET"
  echo "*****User CURL Path*****"
  echo "curl -k -H \"Accept: application/xml\" --user \"${user_name}:$passwd\" https://${server_name}/broker/rest/user -X GET"
  echo "*****Silver CURL Path*****"
  echo "curl -k -H \"Accept: application/xml\" --user \"${user_name}:$passwd\" https://${server_name}/broker/rest/user -d plan_id=silver -X PUT"
  echo "*****Storage CURL Path*****"
  echo "curl -k -X PUT -H \"Accept: application/xml\" --user \"${user_name}:$passwd\" https://${server_name}/broker/rest/domains/${domain_name}/applications/${app_name}/cartridges/ -d additional_gear_storage=5"
  echo "*****Delete all apps******"
  echo "curl -k -X DELETE -H \"Accept: application/xml\" -d force=true --user \"${user_name}:$passwd\"  https://${server_name}/rest/domains/${domain_name}"
  echo "curl -k -X POST -H \"Content-Type: Application/json\" --user \"${user_name}:$passwd\"  https://${server_name}/rest/domains/${domain_name}/applications/${app_name}/events -d '{"event":"make-ha"}' | json_reformat"
fi
