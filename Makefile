help: ## Print this message and exit.
        @awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2 | "sort"}' $(MAKEFILE_LIST)

all: pull-images create-cluster load-images install-istio apply-istio-addons apply-bookinfo

create-cluster: # Create kind cluster
	kind create cluster --config kind-config.yaml
	kubectl wait --for=condition=Ready nodes --all --timeout=1800s

install-istio:
	kubectl label namespace default istio-injection=enabled
	istioctl install --set profile=demo -y --context=kind-istio-testing -f gateway-overlay.yaml

apply-bookinfo:
	kubectl apply -f bookinfo --context=kind-istio-testing

apply-istio-addons:
	kubectl apply -f addons --context=kind-istio-testing

pull-images:
	scripts/kind-pull-images-from-dockerhub.sh

load-images:
	scripts/kind-load-images-into-cluster.sh

dashboard:
	istioctl dashboard kiali

teardown:
	kind delete cluster --name istio-testing