#!/bin/bash

# author: Chunyun Chen
# date: 03/11/2015
# email: chunchen@redhat.com
# IRC: chunchen @ aos-qe

DOCKER_CONFIG=/etc/sysconfig/docker
DOCKER_OPT="--confirm-def-push=false"
IMAGE_REGISTRY="virt-openshift-05.lab.eng.nay.redhat.com:5000"
PUBLIC_IMAGE_REGISTRY="registry.access.redhat.com"
maste_andr_node=$(oc get node | grep Ready | awk '{print $1}')

set -e

function pull_images {
  docker pull $IMAGE_REGISTRY/openshift3/ose-pod:v3.1.0.4
  docker tag $IMAGE_REGISTRY/openshift3/ose-pod:v3.1.0.4 $PUBLIC_IMAGE_REGISTRY/openshift3/ose-pod:v3.1.0.4
  docker pull $IMAGE_REGISTRY/openshift3/ose-deployer:v3.1.0.4
  docker tag $IMAGE_REGISTRY/openshift3/ose-deployer:v3.1.0.4 $PUBLIC_IMAGE_REGISTRY/openshift3/ose-deployer:v3.1.0.4
  docker pull virt-openshift-05.lab.eng.nay.redhat.com:5000/openshift3/ose-haproxy-router:v3.1.0.4
  docker pull virt-openshift-05.lab.eng.nay.redhat.com:5000/openshift3/ose-docker-registry:v3.1.0.4
  docker tag virt-openshift-05.lab.eng.nay.redhat.com:5000/openshift3/ose-haproxy-router:v3.1.0.4 registry.access.redhat.com/openshift3/ose-haproxy-router:v3.1.0.4
  docker tag virt-openshift-05.lab.eng.nay.redhat.com:5000/openshift3/ose-docker-registry:v3.1.0.4 registry.access.redhat.com/openshift3/ose-docker-registry:v3.1.0.4
}

function add_options_to_docker()
{ 
   for node in $maste_andr_node
   do
     echo "#############NOTE##########"
     echo " Never to terminal when running ..."
     echo "#############NOTE##########"
     echo 
     echo "Changing docker option on $node"
     if [ "pull" == "$1" ];
     then
        DOCKER_OPT="--confirm-def-push=false --insecure-registry=$IMAGE_REGISTRY"
        (ssh $node "sed -i 's/\(--insecure-registry=\)/$DOCKER_OPT \1/g' $DOCKER_CONFIG && service docker restart" > /dev/null)
  #      sleep 6
  #      (ssh $node "pull_images" > /dev/null)
     else
        (ssh $node "sed -i 's/\(--insecure-registry=\)/$DOCKER_OPT \1/g' $DOCKER_CONFIG && service docker restart" > /dev/null)
     fi
     sleep 1
     echo "Changed docker daemon agains $node"
   done
}
 
add_options_to_docker
set +e
