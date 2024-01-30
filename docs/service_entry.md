# Istio ServiceEntry Documentation

## Introduction
`ServiceEntry` is an important resource in Istio, enabling you to add an entry into the service registry of Istio. It allows services from outside of your mesh to be available to your mesh services and enables you to manage traffic for external services just like in-mesh services.

## Table of Contents
- [Introduction](#introduction)
- [Basic Concepts](#basic-concepts)
- [Use Cases](#use-cases)
  - [Accessing External Services](#accessing-external-services)
  - [Monitoring and Controlling External Traffic](#monitoring-and-controlling-external-traffic)
- [Examples](#examples)
  - [Access External HTTP Service](#access-external-http-service)
  - [Access External Database](#access-external-database)

## Basic Concepts
`ServiceEntry` enables services within the Istio service mesh to access and route to external services. It essentially extends the reach of the Istio service mesh beyond its traditional boundaries.

## Use Cases

### Accessing External Services
This includes enabling mesh services to access APIs, web services, or any other services hosted outside the mesh.

### Monitoring and Controlling External Traffic
`ServiceEntry` allows for the monitoring and control of traffic to external services, applying Istio features like traffic routing, fault injection, and more.

## Examples

### Access External HTTP Service
Example of a `ServiceEntry` to access an external HTTP service:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: external-svc-google
spec:
  hosts:
  - "www.google.com"
  location: MESH_EXTERNAL
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  resolution: DNS
```
This ServiceEntry allows services in the mesh to access www.google.com over HTTPS.

### Access External Database
Example to access an external database:
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: external-db
spec:
  hosts:
  - "mydb.example.com"
  location: MESH_EXTERNAL
  ports:
  - number: 3306
    name: mysql
    protocol: TCP
  resolution: STATIC
  addresses:
  - 192.0.2.10/32
```
This configuration permits access to an external MySQL database hosted at mydb.example.com.