#!/bin/bash
  
## Note:
## Must change the $user_on_oc to your own OpenShift user name 
## And change the $pem_file to the correct location on your host

port="22"
user="root"
hostname="$1"
password="redhat"
user_on_oc="chunchen"
passwd_on_oc="redhat"
login_cmd_with_dns="oc login $hostname -u $user_on_oc -p $passwd_on_oc"
rm_cmd="rm -f $HOME/.kube/config"
bash_file=~/.bashrc
pem_file=~/cfile/libra-new.pem

function set_origin_variable()
{
    env_origin=$(grep "^alias sshorigin=" $bash_file)
    [ -z "$env_origin" ] && echo "alias sshorigin=\"ssh -o identitiesonly=yes -i $pem_file $user@$hostname\"" >> $bash_file
    [ "$env_origin" ] && sed -i "/sshorigin/c alias sshorigin=\"ssh -o identitiesonly=yes -i $pem_file $user@$hostname\"" $bash_file
    echo -e "Run \033[31;49;1msource $bash_file\033[39;49;0m , then can login master host via command: \033[32;49;1msshorigin\033[39;49;0m"
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
   echo "Login ..."
   echo "Deleted file: $HOME/.kube/config" && eval $rm_cmd
   echo $login_cmd_with_dns && eval $login_cmd_with_dns && set_origin_variable
   if [ "$?" -eq "0" ];
   then
       create_project
   fi
   exit 1
}

if [ $# -lt 1 ];
then
   echo -e " Please input hostname!\n Usage: $0 $hostname"
   exit 1
fi

login
