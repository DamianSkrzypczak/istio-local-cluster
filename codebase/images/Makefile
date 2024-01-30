build:
	docker build -t custom-nginx:0.1.0 .

load:	
	kind load docker-image custom-nginx:0.1.0 --name istio-testing

deploy:
	kubectl apply -f nginx-deployment.yaml