help: ## Print this message and exit
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2 | "sort"}' $(MAKEFILE_LIST)

run:
	docker compose up

compile:
	docker compose run go_plugin_compile

verify:
	@if curl -I localhost:10000 2>&1 | grep --color=auto "rsp-header-from-go"; then \
		echo "Plugin verified successfully"; \
	else \
		echo "Plugin verification failed, expected \"rsp-header-from-go\""; \
	fi

