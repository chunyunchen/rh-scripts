#!/bin/env python

import os
import subprocess
from ConfigParser import SafeConfigParser

class AOS(object):
    '''Make easier for OpenShift tests!'''

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
        AOS.osUser = config.get("user","os_user")
        AOS.osPasswd = config.get("user","os_passwd")
        AOS.masterUser = config.get("user","master_user")
        AOS.master = config.get("master","master")
        AOS.masterConfigRoot = config.get("master","master_config_root")
        AOS.masterConfigFile = config.get("master","master_config_file")
        AOS.kubeConfigFile = config.get("master","kube_config_file")
        AOS.pemFile = config.get("ssh","pem_file")
        AOS.hawkularMetricsAppname = config.get("image","hawkular_metrics_appname")
        AOS.kibanaOpsAppname = config.get("image","kibana_ops_appname")
        AOS.kibanaAppname = config.get("image","kibana_appname")
        AOS.SAMetricsDeployer = config.get("image","serviceaccount_metrics_deployer")
        AOS.HCHStack = config.get("image","hch_stack")
        AOS.imagePrefix = config.get("image","image_prefix")
        AOS.mageVersion = config.get("image","image_version")
        AOS.enablePV = config.getboolean("image","enable_pv")
        AOS.ESRam = config.get("image","elastic_ram")
        AOS.ESClusterSize = config.get("image","elastic_cluster_size")
        AOS.EFKDeployer = config.get("image","efk_deployer")

    @classmethod
    def check_validation(cls,):
        if not AOS.master:
            print "Please config '[master]->master' in config file or specify OpenShift master via '-m' within command line!"
            os.sys.exit()
        print "preparation is well"


if __name__ == "__main__":
   AOS.generate_default_config()
   AOS.get_config()
   AOS.check_validation()
