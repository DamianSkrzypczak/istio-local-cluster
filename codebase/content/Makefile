build:
	docker build -t content:0.1.0 .

load:
	kind load docker-image content:0.1.0 --name istio-testing

deploy:
	kubectl apply -f content-deployment.yaml