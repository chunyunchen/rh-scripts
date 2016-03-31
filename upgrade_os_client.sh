#!/bin/bash

os_yum_repo_file=/etc/yum.repos.d/aos.repo
old_repo_time_file=~/scripts/.old_os_repo_time
from_repo=`grep  ^[^#] $os_yum_repo_file | grep baseurl | awk -F'=' '{print $2}'`

if [ ! -f $old_repo_time_file ];
then
   touch $old_repo_time_file
fi

#set -x
old_repo_time=`sed -n '2p' $old_repo_time_file`
new_repo_time=`curl ${from_repo}/ 2>/dev/null |grep "Packages/" | awk '{print $6" ",$7}'`

if [ x"$old_repo_time" != x"$new_repo_time" ];
then
   sudo yum upgrade atomic-openshift-clients -y
   echo -e "Upgrade OpenShift client from: $from_repo\n$new_repo_time" > $old_repo_time_file
else
   echo "OpenShift client is latest!"
fi
