build:
	docker build -t homepage:0.1.0 .

load:
	kind load docker-image homepage:0.1.0 --name istio-testing

deploy:
	kubectl apply -f homepage-deployment.yaml