#!/bin/bash

# For quickstarts
#echo ">>>>>>>>>Create rails Quickstarts..."
#rhc app create rails ruby-1.9 mysql-5.5 --from-code git://github.com/openshift/rails-example.git --no-git
#sleep 2

#echo ">>>>>>>>>Create kitchensink Quickstarts..."
#rhc app create -a kitchensink  jbossas-7 postgresql-8.4 --from-code git://github.com/openshift/kitchensink-example.git --no-git
#sleep 2

#echo ">>>>>>>>>>Create django27 Quickstarts..."
#rhc app create django27 python-2.7 mysql-5.1 cron-1.4 --from-code git://github.com/openshift/django-example.git --no-git
#sleep 2

# For special scenario
#echo ">>>>>>>>>>>Create app for SNI..."
#rhc app create cphp00 php-5.3 --no-git
#sleep 1
#rhc alias add cphp00 ccy.php.com

echo ">>>>>>>>>>>Add download mock-plugin-0.2 to php application..."
rhc app create cphpmkpgin2 php-5.3 --no-git -g medium
sleep 1
rhc alias add cphpmkpgin2 ccy.cphpmkpgin2.com
rhc cartridge add https://raw.github.com/chunyunchen/mockplugin2/master/metadata/manifest.yml -a cphpmkpgin2
