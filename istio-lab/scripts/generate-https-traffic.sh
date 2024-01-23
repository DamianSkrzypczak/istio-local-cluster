#!/bin/bash

url="https://localhost:32360/productpage"

# test url first
curl curl --cacert cert-manager/basic-self-signed-certificate-for-external-traffic/tls.crt -s -o /dev/null -w "%{http_code}\n" $url
if [ $? -ne 0 ]; then
    echo "Error: test curl failed, url $url is not responding"
    exit 1
fi

batch=0 
while true
do
    ((batch++)) # increment batch counter
    
    N=10 # define number of requests per batch
    for i in {1..$N}
    do
        curl --cacert cert-manager/basic-self-signed-certificate-for-external-traffic/tls.crt -s $url > /dev/null & 
        sleep 0.01
    done

    echo `expr $batch \* $N` requests
done
