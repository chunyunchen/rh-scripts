#!/bin/bash

master_url=`oc project | awk -F'"' '{print $4}'`

if [ "20" == "$1" ];
then
curl -k -H "Authorization: Bearer `oc whoami -t`" -X GET ${master_url}/api/v1/proxy/namespaces/${mns}/services/https:heapster:/api/v1/model/namespaces/${ns}/pods/${pn}/metrics | python -m json.tool
fi

mr=`oc get route | grep hawkular-metrics | awk '{print $2}'`

if [ "11" == "$1" ];
then
curl --insecure -H "Authorization: Bearer `oc whoami -t`" -H "Hawkular-tenant: ${ns}" -X GET https://${mr}/hawkular/metrics/metrics/network/rx?tags={"pod_name":"$pn"} |python -m json.tool
fi

if [ "10" == "$1" ];
then
echo "curl --insecure -H "Authorization: Bearer `oc whoami -t`" -H "Hawkular-tenant: ${ns}" -X GET https://${mr}/hawkular/metrics/metrics |python -m json.tool"
curl --insecure -H "Authorization: Bearer `oc whoami -t`" -H "Hawkular-tenant: ${ns}" -X GET https://${mr}/hawkular/metrics/metrics |python -m json.tool
fi
