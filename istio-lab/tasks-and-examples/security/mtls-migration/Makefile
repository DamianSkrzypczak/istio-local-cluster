help: ## Print this message and exit
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2 | "sort"}' $(MAKEFILE_LIST)

SHELL := /bin/bash

## https://istio.io/latest/docs/tasks/security/authentication/mtls-migration/
setup: ## Setup example 
	kubectl create ns foo
	kubectl apply -f <(istioctl kube-inject -f httpbin.yaml) -n foo
	kubectl apply -f <(istioctl kube-inject -f sleep.yaml) -n foo

	kubectl create ns bar
	kubectl apply -f <(istioctl kube-inject -f httpbin.yaml) -n bar
	kubectl apply -f <(istioctl kube-inject -f sleep.yaml) -n bar

	kubectl create ns legacy
	kubectl apply -f sleep.yaml -n legacy

verify: ## Verify example
	for from in foo bar legacy; do \
		for to in foo bar; do \
			pod=$$(kubectl get pod -l app=sleep -n $$from -o jsonpath='{.items..metadata.name}'); \
			kubectl exec "$$pod" -c sleep -n $$from -- \
			curl http://httpbin.$$to:8000/ip -s -o /dev/null -w "sleep.$$from to httpbin.$$to: %{http_code}\n"; \
		done; \
	done

define PEER_AUTHENTICATION
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
spec:
  mtls:
    mode: STRICT
endef

export PEER_AUTHENTICATION

## https://istio.io/latest/docs/tasks/security/authentication/mtls-migration/#lock-down-to-mutual-tls-by-namespace
lock-down-mtls-by-namespace: ## lock down workloads in the foo namespace to only accept mutual TLS traffic
	@echo "$$PEER_AUTHENTICATION" | kubectl apply -n foo -f -

lock-down-mtls-entire-mesh: ## lock down workloads in all namespaces to only accept mutual TLS traffic
	@echo "$$PEER_AUTHENTICATION" | kubectl apply -n istio-system -f -


teardown: ## Cleanup by removing all created namespaces and peerauthentications
	kubectl delete ns foo bar legacy
	kubectl delete peerauthentication -n foo default
	kubectl delete peerauthentication -n istio-system default
