help: ## Print this message and exit
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2 | "sort"}' $(MAKEFILE_LIST)

### Cluster setup

KIND_CLUSTER_NAME := istio-testing
KIND_CLUSTER_CONTEXT := kind-${KIND_CLUSTER_NAME}

setup: ## Setup kind cluster with cert-manager + istio-csr + istio + bookinfo example app + HTTPS support for ingress gateway  
setup: \
	pull-images \
	create-cluster \
	load-cert-manager-images \
	install-cert-manager \
	create-istio-namespace \
	apply-cert-manager-issuer-and-certificate \
	create-istio-root-ca-certificate-secret \
	install-istio-csr \
	load-istio-images \
	install-istio \
	apply-istio-addons \
	apply-kustomize \
	apply-bookinfo \
	apply-bookinfo-selfsigned-issuer-and-certificate \
	verify-certificate-file

pull-images: ## Pull istio/bookinfo docker images to host machine
	kind-cluster/scripts/kind-pull-all-images-from-dockerhub.sh

create-cluster: ## Create kind cluster
	kind create cluster --name ${KIND_CLUSTER_NAME} --config kind-cluster/kind-config.yaml
	kubectl wait --for=condition=Ready nodes --all --timeout=1800s

load-cert-manager-images: ## Load cert-manager docker images from host to kind cluster
	kind-cluster/scripts/kind-load-cert-manager-images-into-cluster.sh

install-cert-manager: ## Install cert-manager (https://cert-manager.io/docs/)
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml
	kubectl wait --for=condition=available --timeout=600s deployment/cert-manager -n cert-manager
	kubectl wait --for=condition=available --timeout=600s deployment/cert-manager-cainjector -n cert-manager
	kubectl wait --for=condition=available --timeout=600s deployment/cert-manager-webhook -n cert-manager

create-istio-namespace: ## Create istio-system namespace (necessary to be created beforehand for istio-csr)
	kubectl create namespace istio-system

apply-cert-manager-issuer-and-certificate: ## Apply istio-csr selfsigned root issuer / certificate / istio-ca issuer  
	kubectl apply -f istio-csr/
	kubectl wait --for=condition=Ready --timeout=600s issuer/selfsigned -n istio-system
	kubectl wait --for=condition=Ready --timeout=600s certificate/istio-ca -n istio-system
	kubectl wait --for=condition=Ready --timeout=600s issuer/istio-ca -n istio-system

create-istio-root-ca-certificate-secret: ## Download cert-manager-generated certificate and put it as static file for istio-csr to use
	# https://cert-manager.io/docs/tutorials/istio-csr/istio-csr/#export-the-root-ca-to-a-local-file
	# "As such, we'll export our Root CA and configure Istio later using that static cert."

	# Wait for secret to exits
	while ! kubectl get secret istio-ca -n istio-system; do echo "Waiting for istio-ca"; sleep 5; done
	
	# Export our cert from the secret it's stored in, and base64 decode to get the PEM data.
	kubectl get -n istio-system secret istio-ca -ogo-template='{{index .data "tls.crt"}}' | base64 -d > istio-csr/certs/ca.pem
	
	# Out of interest, we can check out what our CA looks like
	openssl x509 -in istio-csr/certs/ca.pem -noout -text
	
	# Add our CA to a secret
	kubectl create secret generic -n cert-manager istio-root-ca --from-file=ca.pem=istio-csr/certs/ca.pem

install-istio-csr: ## Install istio-csr controller (https://cert-manager.io/docs/tutorials/istio-csr/istio-csr/)
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	helm install -n cert-manager cert-manager-istio-csr jetstack/cert-manager-istio-csr \
		--set "app.tls.rootCAFile=/var/run/secrets/istio-csr/ca.pem" \
		--set "volumeMounts[0].name=root-ca" \
		--set "volumeMounts[0].mountPath=/var/run/secrets/istio-csr" \
		--set "volumes[0].name=root-ca" \
		--set "volumes[0].secret.secretName=istio-root-ca"
	kubectl wait --for=condition=available --timeout=600s deployment/cert-manager-istio-csr -n cert-manager

load-istio-images: ## Load istio/bookinfo docker images from host to kind cluster
	kind-cluster/scripts/kind-load-istio-images-into-cluster.sh

install-istio: ## Install istio on kind cluster
	kubectl label namespace default istio-injection=enabled
	istioctl install -y --context=${KIND_CLUSTER_CONTEXT} -f kind-cluster/istio-install-config.yaml

apply-istio-addons: ## Install istio addons (allows for kiali dashboard)
	kubectl apply -f istio-lab/addons --context=${KIND_CLUSTER_CONTEXT}

apply-kustomize: ## Apply cluster_volume/ volume sc/pv/pvc
	kubectl apply -k kind-cluster

apply-bookinfo: ## Install bookinfo tutorial application (https://istio.io/latest/docs/examples/bookinfo/)
	kubectl apply -f istio-lab/bookinfo --context=${KIND_CLUSTER_CONTEXT}

apply-bookinfo-selfsigned-issuer-and-certificate: ## Apply cert-manager selfsigned issuer/certificate for bookinfo gateway
	kubectl apply -f cert-manager/
	kubectl wait --for=condition=Ready --timeout=600s issuer/bookinfo-selfsigned-issuer -n istio-system
	kubectl wait --for=condition=Ready --timeout=600s certificate/bookinfo-selfsigned-certificate -n istio-system

verify-certificate-file: ## Verify certificate returned by HTTPS bookinfo endpoint (checks if ingress gateway uses configured certificate)
	kubectl get secret productpage-certificate -n istio-system -o jsonpath='{.data.tls\.crt}' | base64 --decode > cert-manager/certs/tls.crt
	openssl x509 -in cert-manager/certs/tls.crt -text -noout
	echo "Q" | openssl s_client -connect localhost:32360 -CAfile cert-manager/certs/tls.crt

teardown: ## Delete kind cluster, cleanup setup
	kind delete cluster --name ${KIND_CLUSTER_NAME}

### Cluster life-cycle commands

browser: ## Open (HTTP) main page in browser
	xdg-open http://localhost:31077/productpage

browser-https: ## Open (HTTPS) main page in browser 
	xdg-open https://localhost:32360/productpage
	
browser-all: browser browser-https ## Open HTTP/HTTPS browser pages

dashboard: ## Run kiali dashboard (https://istio.io/latest/docs/ops/integrations/kiali/)
	istioctl dashboard kiali

traffic: ## Run bash script for generating traffic
	istio-lab/scripts/generate-traffic.sh

traffic-https: ## Run bash script for generating traffic
	istio-lab/scripts/generate-https-traffic.sh
