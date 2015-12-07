#!/bin/bash

instance_name=$1
pem_file=~/libra-new.pem

if [ "$instance_name" == "" ]
then
  tmp=`grep -v ^# ~/.openshift/express.conf |grep  libra_server | awk -F'=' '{print $2}'`
  instance_name=`echo ${tmp} | sed  "s/['|\"]//g"`
fi

user_name=${2:-root}

function login()
{
cat > ./login.exp << END 
#!/usr/bin/expect
spawn ssh -i $pem_file $user_name@$instance_name
expect "*(yes|no)*"
send "yes\r"
send "exit\r"
expect eof
interact
END

chmod 700 ./login.exp
/usr/bin/expect ./login.exp
}

# copy the certificates from OpenShift v3 server
if [ ! `echo $instance_name | grep 'ec'` ]; then
   scp -r -i ~/cfile/libra-new.pem $user_name@$instance_name:/var/lib/openshift/openshift.local.certificates /home/chunchen/test/openshift_ca/ose/
else
   scp -i ~/cfile/libra-new.pem ~/.bashrc_just_for_test $user_name@$instance_name:~/.bashrc
   scp -r -i ~/cfile/libra-new.pem $user_name@$instance_name:/data/src/github.com/openshift/origin/examples/sample-app/openshift.local.config/master/* /home/chunchen/test/openshift_ca/origin/
fi

if [ ! "$instance_name" == "" ]
then
  echo ">>>>>>>>>"
  echo "instance name: $instance_name"
  echo "login user name: $user_name"
  echo "<<<<<<<<<"
  ssh -i ~/cfile/libra-new.pem -o IdentitiesOnly=yes $user_name@$instance_name
#  login
else
  echo "Please enter your instance name."
  echo "eg: $0 <instance_name>"
fi

rm -rf ./login.exp
