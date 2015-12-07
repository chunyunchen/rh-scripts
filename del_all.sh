#!/bin/bash

cd /home/vagrant/openshift-origin/origin

#delete services
del_service()
{
  ser_ids=$(_output/go/bin/openshift kube list services | awk '/^[^#]/ && NR>=3 {print $1}')
  for ser_id in $ser_ids
  do
     _output/go/bin/openshift  kube delete services/$ser_id
  done
}

#delete replicationControllers 
del_replicationController()
{
  repl_ids=$(_output/go/bin/openshift kube list replicationControllers | awk '/^[^#]/ && NR>=3 {print $1}')
  for repl_id in $repl_ids
  do
     _output/go/bin/openshift  kube delete replicationControllers/$repl_id
  done
}

#delete imageRepositories
del_imageRepository()
{
  img_ids=$(_output/go/bin/openshift kube list imageRepositories| awk '/^[^#]/ && NR>=3 {print $1}')
  for img_id in $img_ids
  do
     _output/go/bin/openshift  kube delete imageRepositories/$img_id
  done
}

#delete deploymentConfigs
del_deploymentConfig()
{
  depcfg_ids=$(_output/go/bin/openshift kube list deploymentConfigs| awk '/^[^#]/ && NR>=3 {print $1}')
  for depcfg_id in $depcfg_ids
  do
     _output/go/bin/openshift  kube delete deploymentConfigs/$depcfg_id
  done
}

# delete buildConfigs
del_buildConfig()
{
  bldcfg_ids=$(_output/go/bin/openshift kube list buildConfigs| awk '/^[^#]/ && NR>=3 {print $1}')
  for bldcfg_id in $bldcfg_ids
  do
     _output/go/bin/openshift  kube delete buildConfigs/$bldcfg_id
  done
}

#delete pods
del_pod()
{
  pod_ids=$(_output/go/bin/openshift kube list pods | awk '/^[^#]/ && NR>=3 {print $1}')
  for pod_id in $pod_ids
  do
     _output/go/bin/openshift  kube delete pods/$pod_id
  done
}

echo "Delete services ..." && del_service
echo "Delete replicationControllers ... " && del_replicationController
echo "Delete pods ... " && del_pod
echo "Delete imageRepositories... " && del_imageRepository
echo "Delete deploymentConfigs ... " && del_deploymentConfig
echo "Delete buildConfigs ... " && del_buildConfig
