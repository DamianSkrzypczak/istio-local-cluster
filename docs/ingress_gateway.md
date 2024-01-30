# Istio IngressGateway Documentation

## Introduction
The `istio-ingressgateway` plays a pivotal role in Istio's architecture, acting as the entry point for external traffic into the Istio service mesh. It is designed to provide efficient and secure traffic management.

## Table of Contents
- [Introduction](#introduction)
- [Basic Concepts](#basic-concepts)
- [Configuration](#configuration)
  - [Gateway Resource](#gateway-resource)
  - [Securing the Gateway](#securing-the-gateway)
  - [Traffic Management](#traffic-management)
- [Examples](#examples)
  - [Basic Gateway Setup](#basic-gateway-setup)
  - [Securing with TLS](#securing-with-tls)
  - [Routing Rules with VirtualService](#routing-rules-with-virtualservice)

## Basic Concepts
The `istio-ingressgateway` is a dedicated instance of an Envoy proxy. It manages inbound traffic, routing it to the appropriate services within the mesh based on the configured rules.

## Configuration

### Gateway Resource
The Gateway resource is used to configure the `istio-ingressgateway`. It defines how external traffic is processed and routed into the service mesh.

### Securing the Gateway
Security is a critical aspect, and it's possible to secure the ingress gateway using various methods, including TLS and JWT authentication.

### Traffic Management
Traffic management involves defining rules for how traffic is routed after entering the ingress gateway. This is often done in conjunction with `VirtualService` resources.

## Examples

### Basic Gateway Setup
A basic example of setting up an `istio-ingressgateway`:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: my-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
```

This configuration sets up a gateway listening on port 80 for HTTP traffic.

### Securing with TLS
Example to secure the ingress gateway with TLS:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: secure-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: my-credentials
    hosts:
    - "*"
```
This configures the gateway to handle HTTPS traffic on port 443 with the specified TLS credentials.

### Routing Rules with VirtualService
Using VirtualService to define routing rules:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: bookinfo
spec:
  hosts:
  - "bookinfo.example.com"
  gateways:
  - bookinfo-gateway
  http:
  - match:
    - uri:
        exact: /productpage
    route:
    - destination:
        host: productpage
        port:
          number: 9080
```
This directs traffic for the bookinfo.example.com to the productpage service.

