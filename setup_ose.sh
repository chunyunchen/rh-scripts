#!/bin/bash
  
## Note:
## Must change the $user_on_oc to your own OpenShift user name

sed_pattern="\(10.*redhat\.com\|10.*cluster\.local\)"
grep_pattern="(10.*redhat\.com|10.*cluster\.local)"
port="22"
user="root"
host="$1"
password="redhat"
host_file="/etc/hosts"
ca_path=./$host
user_on_oc="chunchen"
passwd_on_oc="redhat"
login_cmd="oc login $host:8443 --certificate-authority=$ca_path/ca.crt -u $user_on_oc -p $passwd_on_oc"
rm_cmd="rm -f $HOME/.kube/config"
bash_file=~/.bashrc

master_hostname=$(grep $host $host_file | awk '{print $2}' | head -1)

function check_login()
{
   if [ "$master_hostname" == "" ];
   then
      master_hostname=$(ssh $user@$host hostname)
      echo "Please add host to $host_file, and delete $master_hostname for other hosts"
      echo "eg: echo $host $master_hostname >> $host_file"
      exit 1
   fi
}

function set_env_variable()
{
    ose_env=$(grep "^alias sshose=" $bash_file)
    [ -z "$ose_env" ] && echo "alias sshose=\"ssh $user@$host\"" >> $bash_file
    [ "$ose_env" ] && sed -i "/sshose/c alias sshose=\"ssh $user@$host\"" $bash_file
    echo -e "Run \033[31;49;1msource $bash_file\033[39;49;0m , then can login master host via command: \033[32;49;1msshose\033[39;49;0m"
}

function gendir()
{
  if [ ! -d $1 ]; then
     mkdir -p $1
  fi
}

function create_project()
{
   projects=`oc get project`
   echo $projects | grep -q ${user_on_oc}pj
   if [ "$?" -ne "0" ];
   then
       echo -e "======\nCreating project(\033[32;49;1m${user_on_oc}pj\033[39;49;0m) for user(${user_on_oc})..."
       oc new-project ${user_on_oc}pj
   fi
}

function login()
{
   gendir $ca_path
   [ ! -f $ca_path/ca.crt ] && scp $user@${master_hostname}:/etc/openshift/master/ca.crt $ca_path > /dev/null
   [ -z $master_hostname ] && master_hostname=$(ssh -o identitiesonly=yes $user@$host hostname)
   login_cmd_with_dns="oc login $master_hostname:8443 --certificate-authority=$ca_path/ca.crt -u $user_on_oc -p $passwd_on_oc"
   echo "Login ..."
   echo "Deleted file: $HOME/.kube/config" && eval $rm_cmd
   (echo $login_cmd  && eval $login_cmd && set_env_variable) || (echo "Try again..." && echo $login_cmd_with_dns && eval $login_cmd_with_dns && set_env_variable)
   if [ "$?" -eq "0" ];
   then
       create_project
   fi
   exit 1
}

if [ $# -lt 1 ];
then
   echo -e " Please input host-IP!\n Usage: $0 $host-IP"
   exit 1
fi

if [ "$master_hostname" != "" -a $# -eq 1 ];
then
   echo "Have setuped ose-env for $host"
   login
fi

if [ "$2" = "-l" ];
then
   check_login
   login
fi

function setup()
{
  echo "Copy ssh-id file to host."
  ssh-copy-id -o identitiesonly=yes -i ~/.ssh/id_rsa.pub $user@$host > /dev/null
 
  master_hostname=$(ssh -o identitiesonly=yes $user@$host hostname)
  egrep -q $grep_pattern $host_file
  rs=$?
  if [ "$rs" = "0" ];
  then
      sudo sed -i "/$sed_pattern/c $host $master_hostname" $host_file
  else
      sudo echo "$host $master_hostname" >> $host_file
  fi

  echo "Add user and passwd wih htpasswd on host."
  ssh -o identitiesonly=yes $user@${master_hostname} htpasswd -b /etc/openshift/htpasswd $user_on_oc $passwd_on_oc > /dev/null
  echo "Copy ca.crt file from host to local."
  gendir $ca_path
  scp $user@${master_hostname}:/etc/openshift/master/ca.crt $ca_path > /dev/null
}

setup
login
