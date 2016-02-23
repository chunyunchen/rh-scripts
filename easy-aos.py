#!/bin/env python

from __future__ import print_function
import os, sys, re, time
import pipes
from subprocess import check_call,check_output,CalledProcessError,STDOUT
from ConfigParser import SafeConfigParser
from argparse import ArgumentParser, Namespace


config = SafeConfigParser()
class AOS(object):
    '''Make easier for OpenShift tests!'''

    osConfig = "./aos.conf"
    osUser=""
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

    SSHIntoMaster=""
    osProject=""
    delProject = False

    @staticmethod
    def generate_default_config():
        '''Create the default config file if not exists'''

        config.add_section("master")
        config.add_section("project")
        config.add_section("image")
        config.add_section("ssh")
        config.set('project','os_user','')
        config.set('project','os_passwd','redhat')
        config.set('project','master_user','root')
        config.set('master','master','')
        config.set('master','master_config_root','/etc/origin/master')
        config.set('master','master_config_file','master-config.yaml')
        config.set('master','kube_config_file','admin.kubeconfig')
        config.set('ssh','pem_file','')
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
    def get_config(args):
        config.read(AOS.osConfig)
        AOS.osUser = config.get("project","os_user")
        AOS.osPasswd = config.get("project","os_passwd")
        AOS.masterUser = config.get("project","master_user")
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
        AOS.imageVersion = config.get("image","image_version")
        AOS.enablePV = config.getboolean("image","enable_pv")
        AOS.ESRam = config.get("image","elastic_ram")
        AOS.ESClusterSize = config.get("image","elastic_cluster_size")
        AOS.EFKDeployer = config.get("image","efk_deployer")

        try:
            if args.m:
                AOS.master = args.m
            if args.p:
                AOS.osProject = args.p
            if args.d:
                AOS.delProject = args.d
        except AttributeError:
            pass

    @staticmethod
    def echo_user_info():
        AOS.echo("User info:")
        print("master: {}".format(AOS.master))
        print("user: {}".format(AOS.osUser))
        print("project: {}".format(AOS.osProject))

    @staticmethod
    def echo_command(cmd="Please wait..."):
        print("[Running Command]: {}\n".format(cmd))

    @staticmethod
    def echo(msg):
        prefix_str = '>' * len('Running Command')
        print("[{}]: {}".format(prefix_str, msg))

    @staticmethod
    def ssh_validation():
        try:
            command = "date > /dev/null"
            remote_command = '%s {}'.format(pipes.quote(command)) % AOS.SSHIntoMaster
            returncode = check_call(remote_command, shell=True,)
            return returncode
        except Exception, errMsg:
            os.sys.exit()

    @classmethod
    def check_validation(cls,args):
        AOS.echo("Checking confiures...")
        AOS.generate_default_config()
        AOS.get_config(args)
        notification_items = []
        if not AOS.master:
            notification_items.append("[master].master")
        if not AOS.osUser:
            notification_items.append("[project].os_user")
        if not AOS.pemFile:
            notification_items.append("[ssh].pem_file")

        if 0 < len(notification_items):
            print("Please set below parameter(s) under %s config file:" % os.path.abspath(AOS.osConfig))
            print('\n'.join(notification_items))
            os.sys.exit()

        AOS.SSHIntoMaster = "ssh -i %s -o identitiesonly=yes -o ConnectTimeout=10 %s@%s" % (os.path.expanduser(AOS.pemFile), AOS.masterUser, AOS.master)
        AOS.osProject = re.match(r'\w+',AOS.osUser).group(0)
        AOS.ssh_validation()
        AOS.echo_user_info()

    @staticmethod
    def run_ssh_command(cmd, asShell=True,ssh=True):
        remote_command = cmd

        if ssh:
            remote_command = '%s {}'.format(pipes.quote(cmd)) % AOS.SSHIntoMaster

        AOS.echo_command(remote_command)

        try:
            outputs = check_output(remote_command, shell=asShell, stderr=STDOUT)
            return outputs
        except (CalledProcessError,OSError),e:
            if "no process found" not in e.output:
                AOS.echo_command(remote_command)
                AOS.echo(e.output)
                print("Aborted!!!")
                os.sys.exit()

    @classmethod
    def do_permission(cls,role_type,role_name,user=None):

        if not user:
            user = AOS.osUser
        enableSSH = False
        pre_cmd = "oc policy"
        if re.match(r".*(cluster|scc-).*",role_type):
            enableSSH = True
            pre_cmd = "oadm policy"
        if "add-" in role_type:
            if "cluster" in role_type:
                AOS.echo("Note: *%s* user has '%s' admin role! Be Careful!!!" % (user,role_name))
            else:
                AOS.echo("Added '%s' role to *%s* user!" % (role_name,user))
        elif "remove-" in role_type:
            AOS.echo("Removed '%s' role from *%s* user." % (role_name,user))
        command = "%s %s %s %s" % (pre_cmd,role_type,role_name,user)
        AOS.run_ssh_command(command,ssh=enableSSH)

    @staticmethod
    def resource_validate(cmd, reStr, dstNum=3, enableSsh=False):
        AOS.echo("Wait above operation to finished...")

        iloop = 50
        interval = 6
        timeout = iloop * interval
        while dstNum != len(re.findall(reStr,AOS.run_ssh_command(cmd,ssh=enableSsh))) and 0 < iloop:
            time.sleep(interval)
            iloop -= 1

        if iloop == 0:
            AOS.echo("Operation is not finished, timeout {} seconds".format(timeout))
            os.sys.exit()

    @classmethod
    def add_project(cls):
        if AOS.delProject:
            AOS.echo("Deleting project *{}*".format(AOS.osProject))
            project = re.findall(AOS.osProject,AOS.run_ssh_command("oc get project",ssh=False))
            if 0 < len(project):
                AOS.run_ssh_command("oc delete project {}".format(AOS.osProject),ssh=False)
                AOS.resource_validate("oc get projects", r".*{}.*".format(AOS.osProject), dstNum=0)

        outputs = AOS.run_ssh_command("oc get projects", ssh=False)
        project = re.findall(r".*{}.*".format(AOS.osProject), outputs)
        if 0 == len(project):
            AOS.echo("Creating project *{}*".format(AOS.osProject))
            AOS.run_ssh_command("oc new-project {}".format(AOS.osProject),ssh=False)

        AOS.run_ssh_command("oc project {}".format(AOS.osProject), ssh=False)

    @staticmethod
    def loginedOnce():
        outputs = AOS.run_ssh_command("oc config current-context", ssh=False)
        loginCMD = "oc login {0} -u {1} -p {2}".format(AOS.master, AOS.osUser, AOS.osPasswd)
        if AOS.master.replace('.','-') not in outputs:
            print("[ IMPORTANT ] Need login this master once by manual! [ IMPORTANT ]")
            print("Please run below login command line:")
            print(loginCMD)
            os.sys.exit()

    @classmethod
    def login_server(cls):
        AOS.loginedOnce()
        AOS.run_ssh_command("oc login %s -u %s -p %s" % (AOS.master,AOS.osUser,AOS.osPasswd),ssh=False)
        AOS.add_project()

    @classmethod
    def get_subdomain(cls):
        masterConfig = os.path.join(AOS.masterConfigRoot, AOS.masterConfigFile)
        outputs = AOS.run_ssh_command("grep subdomain {}".format(masterConfig))
        subdomain = outputs.split('"')[1]
        return subdomain

    @classmethod
    def delete_oauth(cls):
        oauth = re.findall(r"kibana-proxy", AOS.run_ssh_command("oc get oauthclients -n openshift-infra"))
        if 0 < len(oauth):
            AOS.run_ssh_command("oc delete oauthclients kibana-proxy -n openshift-infra")
            AOS.resource_validate("oc get oauthclients -n openshift-infra",r"kibana-proxy",dstNum=0)

    @classmethod
    def set_annotation(cls, imageStreams):
        isList = [x.split()[0] for x in imageStreams.strip().split('\n')]
        for osIS in isList:
            AOS.run_ssh_command('oc patch imagestreams {}  -p {}'.format(osIS, pipes.quote('{"metadata":{"annotations":{"openshift.io/image.insecureRepository":"true"}}}')), ssh=False)

    @classmethod
    def start_metrics_stack(cls):
        AOS.login_server()
        AOS.echo("starting metrics stack...")
        AOS.run_ssh_command("oc create -f %s" % AOS.SAMetricsDeployer, ssh=False)
        AOS.do_permission("add-cluster-role-to-user", "cluster-reader", user="system:serviceaccount:%s:heapster" % AOS.osProject)
        AOS.do_permission("add-role-to-user","edit", user="system:serviceaccount:%s:metrics-deployer" % AOS.osProject)
        AOS.run_ssh_command("oc secrets new metrics-deployer nothing=/dev/null",ssh=False)
        AOS.run_ssh_command("oc process openshift//metrics-deployer-template -v HAWKULAR_METRICS_HOSTNAME=%s.$SUBDOMAIN,\
        IMAGE_PREFIX=$Image_prefix,IMAGE_VERSION=$Image_version,USE_PERSISTENT_STORAGE=$Use_pv,MASTER_URL=https://$OS_MASTER:8443\
        |oc create -f -" %s (AOS.hawkularMetricsAppname,), ssh=False)
        AOS.resource_validate("oc get pods -n %s" % AOS.osProject,r".*[heapster|hawkular].*Running.*")

    @classmethod
    def start_logging_stack(cls):
        AOS.login_server()
        AOS.echo("Start deploying logging stack pods...")
        AOS.run_ssh_command("oc secrets new logging-deployer nothing=/dev/null",ssh=False)
        AOS.run_ssh_command('echo -e "apiVersion: v1\nkind: ServiceAccount\nmetadata:\n    name: logging-deployer\nsecrets:\n- name: logging-deployer"| oc create -f -',\
                            ssh=False)
        AOS.do_permission("add-cluster-role-to-user", "cluster-admin")
        AOS.delete_oauth()
        AOS.do_permission("add-role-to-user","edit",user="system:serviceaccount:{}:logging-deployer".format(AOS.osProject))
        AOS.do_permission("add-cluster-role-to-user","cluster-reader",user="system:serviceaccount:{}:aggregated-logging-fluentd".format(AOS.osProject))
        AOS.do_permission("add-scc-to-user","privileged",user="system:serviceaccount:{}:aggregated-logging-fluentd".format(AOS.osProject))
        subdomain = AOS.get_subdomain()
        cmd = "oc process openshift//logging-deployer-template -v ENABLE_OPS_CLUSTER=false,IMAGE_PREFIX={prefix},KIBANA_HOSTNAME={kName}.{subdomain},KIBANA_OPS_HOSTNAME={opsName}.{subdomain},PUBLIC_MASTER_URL=https://{master}:8443,ES_INSTANCE_RAM={ram},ES_CLUSTER_SIZE={size},IMAGE_VERSION={version},MASTER_URL=https://{master}:8443|oc create -f -"\
                                                                                         .format(prefix=AOS.imagePrefix,kName=AOS.kibanaAppname,\
                                                                                          subdomain=subdomain,opsName=AOS.kibanaOpsAppname,
                                                                                          master=AOS.master,ram=AOS.ESRam,\
                                                                                          size=AOS.ESClusterSize,version=AOS.imageVersion)
        AOS.run_ssh_command(cmd,ssh=False)
        AOS.resource_validate("oc get pods -n {}".format(AOS.osProject), r"logging-deployer.+Completed", dstNum=1)
        AOS.run_ssh_command("oc process logging-support-template -n {project}| oc create -n {project} -f -".format(project=AOS.osProject), ssh=False)
        imageStreams = AOS.run_ssh_command("oc get is --no-headers -n {}".format(AOS.osProject), ssh=False)
        AOS.set_annotation(imageStreams)
        AOS.do_permission("remove-cluster-role-from-user", "cluster-admin")

    @classmethod
    def start_origin_openshift(cls):
        AOS.echo("Starting OpenShift Service...")
        outputs = AOS.run_ssh_command("openshift start --public-master=%s:8443 --write-config=/etc/origin" % AOS.master)
        nodeConfigPath = outputs.rstrip().split()[-1]
        nodeConfig = os.path.join(nodeConfigPath,"node-config.yaml")
        masterConfig = os.path.join(AOS.masterConfigRoot, AOS.masterConfigFile)
        kubeConfig = os.path.join(AOS.masterConfigRoot, AOS.kubeConfigFile)
        AOS.run_ssh_command("sed -i -e '/loggingPublicURL:/d' -e '/metricsPublicURL:/d' %s" % masterConfig)
        AOS.run_ssh_command("killall openshift")
        AOS.run_ssh_command("echo export KUBECONFIG=%s >> ~/.bashrc; nohup openshift start --node-config=%s --master-config=%s &> openshift.log &" % (kubeConfig,nodeConfig,masterConfig))
        AOS.resource_validate("oc get projects", r"Active")

        # For automation cases related admin role
        master = AOS.master.replace('.','-')
        AOS.run_ssh_command("oc config use-context default/%s:8443/system:admin && mkdir -p /root/.kube && cp /etc/origin/master/admin.kubeconfig /root/.kube/config" % master)
        outputs = AOS.run_ssh_command("oc get pods -n default")
        allRunningPods = re.findall(r'docker-registry.*Running.*|router-1.*Running.*', outputs)
        if 0 == len(allRunningPods):
            AOS.create_default_pods()
            AOS.create_imagestream_into_openshift_project()
            AOS.pull_metrics_and_logging_images()
            AOS.clone_metrics_and_logging_gitrepos()
        AOS.echo("Success! OpenShift Server is UP. ^_^")

    @staticmethod
    def clone_metrics_and_logging_gitrepos():
        AOS.echo("Cloning logging/metrics git repos to %s under $HOME dir for building related images..." % AOS.master)
        cmd = "git clone https://github.com/openshift/origin-metrics.git; git clone https://github.com/openshift/origin-aggregated-logging.git"
        AOS.run_ssh_command(cmd)

    @staticmethod
    def create_imagestream_into_openshift_project():
        AOS.echo("Creating basic imagestream and metrics/logging templates in *openshift* namespace...")
        cmd = "oc create -n openshift -f https://raw.githubusercontent.com/openshift/origin/master/examples/image-streams/image-streams-rhel7.json && oc create -n openshift -f https://raw.githubusercontent.com/openshift/origin-metrics/master/metrics.yaml && oc create -n openshift -f https://raw.githubusercontent.com/openshift/origin-aggregated-logging/master/deployment/deployer.yaml"
        AOS.run_ssh_command(cmd)

    @staticmethod
    def pull_metrics_and_logging_images():
        AOS.echo("Pulling down metrics and logging images form DockerHub registry...")
        imagePrefixs = {"openshift/origin-","registry.access.redhat.com/openshift3/"}
        images = {"metrics-hawkular-metrics","metrics-heapster","metrics-cassandra","metrics-deployer",\
                  "logging-kibana","logging-fluentd","logging-elasticsearch","logging-auth-proxy","logging-deployment"}
        cmd = ';'.join([' '.join(['docker pull',imagePrefix+image]) for imagePrefix in imagePrefixs for image in images])
        AOS.run_ssh_command(cmd)

    @staticmethod
    def create_default_pods():
        # Backup: --images='openshift/origin-${component}:latest
        AOS.run_ssh_command("oc delete dc --all -n default; oc delete rc --all -n default; oc delete pods --all -n default; oc delete svc --all -n default; oc delete is --all -n openshift")
        # Add permission for creating router
        AOS.run_ssh_command("oadm policy add-scc-to-user privileged system:serviceaccount:default:default")
        AOS.echo("Starting to create registry and router pods")
        cmd = "export CURL_CA_BUNDLE=/etc/origin/master/ca.crt; \
                  chmod a+rwX /etc/origin/master/admin.kubeconfig; \
                  chmod +r /etc/origin/master/openshift-registry.kubeconfig; \
                  oadm registry --create --credentials=/etc/origin/master/openshift-registry.kubeconfig --config=/etc/origin/master/admin.kubeconfig; \
                  oadm  router --credentials=/etc/origin/master/openshift-router.kubeconfig --config=/etc/origin/master/admin.kubeconfig --service-account=default"
        AOS.run_ssh_command(cmd)

    @classmethod
    def args_handler(cls):
        # Global options
        commonArgs = ArgumentParser(add_help=False)
        commonArgs.add_argument("-m", help="OpenShift server DNS,eg: ec2-52-23-180-133.compute-1.amazonaws.com")
        commonArgs.add_argument("--version", action="version", version="%(prog)s 1.0", help="Display version")
    
        # Options for sub-command
        subCommonArgs = ArgumentParser(add_help=False)
        subCommonArgs.add_argument('-p', help="Specify OpenShift project")
        subCommonArgs.add_argument('-d', action="store_true",\
                                         help="Delete OpenShift project and Re-create. Default value is False")
    
        commands = ArgumentParser(parents=[commonArgs],description="Setup OpenShift on EC2 or Deploy metrics/logging stack")
        subCommands = commands.add_subparsers(title='subcommands:')
    
        # Sub-command for starting OpenShift server
        startos = subCommands.add_parser('startos', parents=[commonArgs],\
                                                    description="Start OpenShift server",\
                                                    help="start OpenShift service")
        startos.set_defaults(subcommand=AOS.start_origin_openshift)
    
        # Sub-command for deploying metrics stack
        metrics = subCommands.add_parser('metrics',parents=[commonArgs,subCommonArgs],\
                                                   description="Deploy metrics stack pods",\
                                                   help="Deploy metrics stack pods")
        metrics.set_defaults(subcommand=AOS.start_metrics_stack)
    
        # Sub-command for deploying logging stack
        logging = subCommands.add_parser('logging', parents=[commonArgs,subCommonArgs],\
                                                    description="Deploy logging stack pods",\
                                                    help="Deploy logging stack pods")
        logging.set_defaults(subcommand=AOS.start_logging_stack)
    
        args = commands.parse_args()
        AOS.check_validation(args)
     
        return args

if __name__ == "__main__":
    args = AOS.args_handler() 
    args.subcommand()
