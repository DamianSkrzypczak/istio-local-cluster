#!/bin/bash

url="http://localhost:31077/productpage"

# test url first
curl -s -o /dev/null -w "%{http_code}\n" $url
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
        curl -s $url > /dev/null & 
        sleep 0.01
    done

    echo `expr $batch \* $N` requests
done
