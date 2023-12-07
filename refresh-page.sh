#!/bin/bash

# URL to which the curl request will be made
url="http://localhost:31077/productpage"

curl -v $url

# Infinite loop
while true
do
    # Inner loop for 10 requests
    for i in {1..10}
    do
        curl -s $url > /dev/null & 
        # echo $i
        sleep 0.01
    done
done
