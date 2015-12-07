#!/bin/bash

cmd='osc'
if [ $# -ge 1 ]; then
   cmd=$1
fi

resources="imageStreams/python-33-rhel7 services/frontend routes/route-edge imagestreams/origin-ruby-sample imagestreams/ruby-20-centos7 buildconfigs/ruby-sample-build deploymentconfigs/frontend services/database deploymentconfigs/database imagestreams/origin-custom-docker-builder"

for resource in $resources
do
   mes=`$cmd delete $resource` 
   if [ "$mes" != '' ];then
      echo "$mes - deleted"
   else
      echo "$resource - not existing"
   fi
   
done
