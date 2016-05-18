#!/bin/bash
  mkdir /chunchen/metrics
  chown -R nfsnobody:nfsnobody /chunchen/metrics
  echo '/chunchen/metrics *(rw)' >> /etc/exports
  chmod 777 /chunchen/metrics
  exportfs -a
  setsebool -P virt_use_nfs 1
