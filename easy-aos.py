#!/bin/env python

import os
import subprocess
from ConfigParser import SafeConfigParser

class AOS(object):
    '''Make easier for OpenShift tests!'''

    def __init__(self):
        pass

    osConfig = "./aos.config"
    osUSer=""
    osPasswd=""
    masterUser=""
    master=""
    masterConfigRoot=""
    masterConfigFile=""
    kubeConfigFile=""
    pemFile=""
    hawkularMetricsAppname=""
    kibanaOpsAppname=""
    kibanaAppname=""
    SAMetricsDeployer=""
    HCHStack=""
    imagePrefix=""
    imageVersion=""
    enablePV=""
    ESRam=""
    ESClusterSize=1
    EFKDeployer=""

    @staticmethod
    def generate_default_config():
        '''Create the default config file if not exists'''
    
        config = SafeConfigParser()
        config.add_section("user")
        config.add_section("master")
        config.add_section("image")
        config.add_section("ssh")
        config.set('user','os_user','chunchen')
        config.set('user','os_passwd','redhat')
        config.set('user','master_user','root')
        config.set('master','master','')
        config.set('master','master_config_root','/etc/origin/master')
        config.set('master','master_config_file','master-config.yaml')
        config.set('master','kube_config_file','admin.kubeconfig')
        config.set('ssh','pem_file','~/cfile/libra-new.pem')
        config.set('image','hawkular_metrics_appname','hawkular-metrics')
        config.set('image','kibana_ops_appname','kibana-ops')
        config.set('image','kibana_appname','kibana')
        config.set('image','serviceaccount_metrics_deployer','https://raw.githubusercontent.com/openshift/origin-metrics/master/metrics-deployer-setup.yaml')
        config.set('image','hch_stack','https://raw.githubusercontent.com/openshift/origin-metrics/master/metrics.yaml')
        config.set('image','image_prefix','rcm-img-docker01.build.eng.bos.redhat.com:5001/openshift3/')
        config.set('image','image_version','latest')
        config.set('image','enable_pv','False')
        config.set('image','elastic_ram','1024M')
        config.set('image','elastic_cluster_size','1')
        config.set('image','efk_deployer','https://raw.githubusercontent.com/openshift/origin-aggregated-logging/master/deployment/deployer.yaml')
        if not os.path.isfile(AOS.osConfig):
           with open(AOS.osConfig, 'wb') as defaultconfig:
               config.write(defaultconfig)
    
    @staticmethod
    def get_config():
        config = SafeConfigParser()
        config.read(AOS.osConfig)

    @classmethod
    def echo_msg(cls,msg):
        print msg


if __name__ == "__main__":
   AOS.generate_default_config()
   AOS.get_config()
   AOS.echo_msg("hello, you!")
