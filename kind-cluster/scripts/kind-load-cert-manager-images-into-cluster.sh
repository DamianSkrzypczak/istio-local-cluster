#!/bin/bash

docker_images=(
    # cert-manager images
    quay.io/jetstack/cert-manager-controller:v1.13.3
    quay.io/jetstack/cert-manager-cainjector:v1.13.3
    quay.io/jetstack/cert-manager-webhook:v1.13.3
    quay.io/jetstack/cert-manager-istio-csr:v0.7.1
)

total_images=${#docker_images[@]}
for ((i=0; i<total_images; i++)); do
    image=${docker_images[i]}
    counter=$((i+1))
    echo "########################################## [$counter/$total_images]: $image ##########################################"
    kind load docker-image "$image" --name istio-testing
done
