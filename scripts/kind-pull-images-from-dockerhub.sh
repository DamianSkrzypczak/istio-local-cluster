#!/bin/bash

docker_images=(
    # bookinfo
    "docker.io/istio/examples-bookinfo-details-v1:1.18.0"
    "docker.io/istio/examples-bookinfo-ratings-v1:1.18.0"
    "docker.io/istio/examples-bookinfo-reviews-v1:1.18.0"
    "docker.io/istio/examples-bookinfo-reviews-v2:1.18.0"
    "docker.io/istio/examples-bookinfo-reviews-v3:1.18.0"
    "docker.io/istio/examples-bookinfo-productpage-v1:1.18.0"

    # addons
    "docker.io/grafana/grafana:9.5.5"
    "docker.io/jaegertracing/all-in-one:1.46"
    "quay.io/kiali/kiali:v1.76"   
    "docker.io/grafana/loki:2.7.3"
    "prom/prometheus:v2.41.0"
    "jimmidyson/configmap-reload:v0.8.0"
)

total_images=${#docker_images[@]} 
for ((i=0; i<total_images; i++)); do
    image=${docker_images[i]}
    counter=$((i+1))
    echo "########################################## [$counter/$total_images]: $image ##########################################"
    docker pull "$image"
done
