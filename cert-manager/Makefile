setup-cert-manager-integration: \
	install-cert-manager \
	create-self-signed-issuer \
	create-certificate \
	apply-bookinfo-gateway-override \
	dump-crt \
	view-crt-file \
	verify-crt-file \
	verify-crt-via-client

install-cert-manager:
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml
	kubectl wait --for=condition=available --timeout=600s deployment/cert-manager -n cert-manager
	kubectl wait --for=condition=available --timeout=600s deployment/cert-manager-cainjector -n cert-manager
	kubectl wait --for=condition=available --timeout=600s deployment/cert-manager-webhook -n cert-manager

create-self-signed-issuer:
	kubectl apply -f self-signed-issuer.yaml
	kubectl wait --for=condition=Ready --timeout=600s issuer/selfsigned-issuer -n istio-system

create-certificate:
	kubectl apply -f self-signed-cert.yaml
	kubectl wait --for=condition=Ready --timeout=600s certificate/istio-selfsigned-certificate -n istio-system

apply-bookinfo-gateway-override:
	kubectl apply -f bookinfo-gateway-override.yaml

dump-crt:
	kubectl get secret productpage-certificate -n istio-system -o jsonpath='{.data.tls\.crt}' | base64 --decode > tls.crt

view-crt-file:
	openssl x509 -in tls.crt -text -noout

verify-crt-file:
	openssl verify -CAfile tls.crt tls.crt

verify-crt-via-client:
	echo "Q" | openssl s_client -connect localhost:32360 -CAfile tls.crt



