help: ## Print this message and exit
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2 | "sort"}' $(MAKEFILE_LIST)

setup: _setup-plugin _apply-plugin ## Setup envoy http filter (golang plugin)

_setup-plugin: # compile golang plugin
	# this step is done in envoy-lab/ because its also part of standalone envoy http filter golang plugin example
	cd ../../envoy-lab/go-envoy-filters/http && $(MAKE) compile

	# move compiled .so file to cluster_volume
	cp ../../envoy-lab/go-envoy-filters/http/lib/simple.so ../../cluster_volume

_apply-plugin: # patch sidecar and configure it with EnvoyFilter
	# patch productpage sidecar annotations to mount cluster_volume/ to sidecar
	kubectl patch deployment productpage-v1 --patch-file bookinfo-sidecar-mount.patch.yaml

	# apply EnvoyFilter to configure sidecar to use plugin
	# (this is possible because most probably Istio utilizes envoy contrib for its own plugins/extensions)
	# (https://www.envoyproxy.io/docs/envoy/latest/start/install#contrib-builds)
	kubectl apply -f envoy-filter.yaml


verify: ## Verify if plugin is working properly
	@if curl -I localhost:31077/productpage 2>&1 | grep --color=auto "rsp-header-from-go"; then \
		echo "Plugin verified successfully"; \
	else \
		echo "Plugin verification failed, expected \"rsp-header-from-go\""; \
	fi

teardown: ## Teardown golang plugin setup
	# undo patch
	kubectl patch deployment productpage-v1 --patch-file bookinfo-sidecar-mount.unpatch.yaml
	# delete envoy filter object
	kubectl delete -f envoy-filter.yaml
