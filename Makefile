help: ## Print this message and exit
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2 | "sort"}' $(MAKEFILE_LIST)


### Setup

KIND_CLUSTER_NAME := istio-testing
KIND_CLUSTER_CONTEXT := kind-${KIND_CLUSTER_NAME}

all: pull-images create-cluster load-images install-istio apply-istio-addons apply-bookinfo ## Setup kind cluster with istio + bookinfo

pull-images: ## Pull istio/bookinfo docker images to host machine
	kind-cluster/scripts/kind-pull-images-from-dockerhub.sh

create-cluster: ## Create kind cluster
	kind create cluster --name ${KIND_CLUSTER_NAME} --config kind-cluster/kind-config.yaml
	kubectl wait --for=condition=Ready nodes --all --timeout=1800s

load-images: ## Load istio/bookinfo docker images from host to kind cluster
	kind-cluster/scripts/kind-load-images-into-cluster.sh

install-istio: ## Install istio on kind cluster
	kubectl label namespace default istio-injection=enabled
	istioctl install --set profile=demo -y --context=${KIND_CLUSTER_CONTEXT} -f kind-cluster/istio-ingressgateway-override.yaml

apply-istio-addons: ## Install istio addons (allows for kiali dashboard)
	kubectl apply -f istio-lab/addons --context=${KIND_CLUSTER_CONTEXT}

apply-bookinfo: ## Install bookinfo tutorial application (https://istio.io/latest/docs/examples/bookinfo/)
	kubectl apply -f istio-lab/bookinfo --context=${KIND_CLUSTER_CONTEXT}


### Cluster life-cycle commands

dashboard: ## Run kiali dashboard (https://istio.io/latest/docs/ops/integrations/kiali/)
	istioctl dashboard kiali

teardown: ## Delete kind cluster, cleanup setup
	kind delete cluster --name ${KIND_CLUSTER_NAME}

traffic: ## Run bash script for generating traffic
	istio-lab/scripts/generate-traffic.sh