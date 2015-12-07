########################################
#confiure unauthenticated DNS updates
# cd /home/jenkins3/workspace/OSE_V3_Ansible_Installer/ ====> vim hosts ===> ansible-playbook -i hosts openshift-ansible/playbooks/byo/config.yml
# Write SkyDNS to etcd
# curl  --cacert /etc/origin/master/ca.crt --cert /etc/origin/master/master.etcd-client.crt --key /etc/origin/master/master.etcd-client.key -XPUT https://master.cluster.local:4001/v2/keys/skydns/local/cluster/master -d value='{Host: 10.66.79.97}'
########################################

#/bin/bash
domain=$1
named_ip_addr=`ip addr show|awk  '/inet .*global/ {split($2,a,"/");print a[1]}'`
nameservers=`ip addr show|awk  '/inet .*global/ {split($2,a,"/");print a[1]";"}'`
named_hostname=`uname -n`  #such as named.#{domain}

#generate control key in /etc/rhdc.key
rndc-confgen -a -r /dev/urandom
restorecon /etc/rndc.* /etc/named.*
chown root:named /etc/rndc.key
chmod 640 /etc/rndc.key

# Set up DNS forwarding.
cat <<EOF > /var/named/forwarders.conf
forwarders { ${nameservers}; } ;
EOF
restorecon /var/named/forwarders.conf
chmod 644 /var/named/forwarders.conf

# Install the configuration file for the OpenShift Enterprise domain
# name.
rm -rf /var/named/dynamic
mkdir -p /var/named/dynamic


# Create the initial BIND database.
nsdb=/var/named/dynamic/${domain}.db
cat <<EOF > $nsdb
\$ORIGIN .
\$TTL 1 ; 1 seconds (testing only)
${domain}               IN SOA  ${named_hostname}. hostmaster.${domain}. (
                                2011112904 ; serial
                                60         ; refresh (1 minute)
                                15         ; retry (15 seconds)
                                1800       ; expire (30 minutes)
                                10         ; minimum (10 seconds)
                                )
                        NS      ${named_hostname}.
                        MX      10 mail.${domain}.
\$ORIGIN ${domain}.
${named_hostname%.${domain}}                    A       ${named_ip_addr}
EOF


  chgrp named -R /var/named
  chown named -R /var/named/dynamic
  restorecon -rv /var/named

  # Replace named.conf.
  cat <<EOF > /etc/named.conf
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ example named configuration files.
//

options {
        listen-on port 53 { any; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        allow-query     { any; };
        recursion yes;

        /* Path to ISC DLV key */
        bindkeys-file "/etc/named.iscdlv.key";

        // set forwarding to the next nearest server (from DHCP response
        forward only;
        include "forwarders.conf";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

// use the default rndc key
include "/etc/rndc.key";
 
controls {
        inet 127.0.0.1 port 953
        allow { 127.0.0.1; } keys { "rndc-key"; };
};

include "/etc/named.rfc1912.zones";

#include "${domain}.key";    

zone "${domain}" IN {
        type master;
        file "dynamic/${domain}.db";
        allow-update { any ; } ; ##this option allow any server to update DNS without key
};
EOF

chown root:named /etc/named.conf
chcon system_u:object_r:named_conf_t:s0 -v /etc/named.conf

# Configure named to start on boot.
lokkit  --service=dns
chkconfig named on

# Start named so we can perform some updates immediately.
service named restart
