# Setting Up Ingress Gateway and Virtual Service for the "Homepage" Application

In this step, we delve into configuring an Ingress Gateway and a Virtual Service in Istio to expose the "Homepage" application, a dockerized Python app, to external traffic. We will guide you through deploying the application, setting up the Ingress Gateway, and applying a Virtual Service to route traffic to your app.

### Prerequisites

Ensure that you have:

- A running kind cluster with Istio and Istio addons installed.
- Applied kustomization for PVC/PV/SC from the previous step.

### Overview of Steps

### Table of Contents

1. [Deploy "Homepage" Application](#1-deploy-homepage-application)
2. [Verify Application Is Not Yet Accessible](#2-verify-application-is-not-yet-accessible)
3. [Deploy Ingress Gateway and Virtual Service](#3-deploy-ingress-gateway-and-virtual-service)
4. [Access the "Homepage" Application Externally](#4-access-the-homepage-application-externally)
5. [Conclusion](#5-conclusion)
6. [Understanding the Ingress Gateway and Virtual Service YAML Configurations](#6-understanding-the-ingress-gateway-and-virtual-service-yaml-configurations)
    - [Ingress Gateway Configuration](#ingress-gateway-configuration)
    - [Virtual Service Configuration](#virtual-service-configuration)




### Detailed Steps

#### 0. Change current working directory
```
cd codebase/homepage
```

#### 1. **Build and deploy "Homepage" Application**

Deploy the "Homepage" application using the provided Kubernetes manifests. This sets up a Service, a ServiceAccount, and a Deployment for the "Homepage" app.

```bash
make build load
kubectl apply -f homepage-deployment.yaml
```

### 2. Verify That Application Is <span style="color:#ff7f7f">Not Yet Accessible</span>.

Initially, the "Homepage" application is not externally accessible. To verify this:

Try accessing http://localhost:31077. You should see no response.

<details>
<summary>Why It's Inaccessible?</summary>
At this point, the application is running internally within the cluster, but we haven't yet configured external access through an Ingress Gateway and a Virtual Service.
</details>

### 3. Deploy Ingress Gateway and Virtual Service

Now, deploy the Ingress Gateway and Virtual Service to expose the "Homepage" application.

#### Ingress Gateway: Managing External Access

The Ingress Gateway in Istio is a crucial component that controls the entry of external traffic into your Kubernetes cluster. It acts as a gatekeeper, ensuring that only authorized and intended traffic can access the services running inside the cluster. 

Unlike traditional Kubernetes Ingress, which operates at the edge of the cluster, Istio's Ingress Gateway is more integrated into the cluster's internal networking and leverages Istio's advanced routing capabilities.

#### Deploying the Ingress Gateway:
```bash
kubectl apply -f homepage-ingressgateway.yaml
```

#### Virtual Service: Routing the Traffic

Once the Ingress Gateway receives the traffic, the next step is to route it to the correct service. This is where the Virtual Service comes into play. 

A Virtual Service in Istio is a resource that defines how requests are routed within the service mesh. It specifies the rules for routing traffic to various services based on request attributes like URI, headers, and more. This allows for sophisticated routing strategies, like canary deployments and A/B testing. 

Virtual Services can route traffic to multiple backend services, enabling patterns like microservices aggregation or service splitting. 

When used with an Ingress Gateway, a Virtual Service binds these routing rules to the external traffic entering through the Gateway.

#### Applying the Virtual Service:

```bash
kubectl apply -f homepage-virtualservice.yaml
```

### 4. Verify That Application Is <span style="color:#90EE90">Accessible</span>.

After deploying the Ingress Gateway and Virtual Service, your "Homepage" application should now be accessible externally.

- Open a web browser and go to http://localhost:31077. You should now see the frontend of your "Homepage" application.

> [!TIP]
>
> If you encounter issues, use `kubectl logs` on the ingressgateway and kubectl describe on the services and deployments to troubleshoot.

### 5. Conclusion

By following these steps, you have successfully exposed your "Homepage" application to external traffic using Istio's Ingress Gateway and Virtual Service, enabling users to access it through a web browser.

### 6. Understanding the Ingress Gateway and Virtual Service YAML Configurations

As part of the "Setting Up Ingress Gateway and Virtual Service for the 'Homepage' Application" step, it's crucial to understand the configuration details of the Ingress Gateway and Virtual Service YAML files. Let's delve into the specifics of each configuration and what they accomplish.

#### Ingress Gateway Configuration

Our Ingress Gateway is defined in the following YAML:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: homepage-gateway # The name of the Gateway resource.
spec:
  selector: # Determines which pods will match this Gateway.
    istio: ingressgateway # use istio default controller
  servers:
    - port:
        number: 8080
        name: http
        protocol: HTTP
      hosts:
        - '*' # A list of hosts exposed by this gateway. * mean all hosts are exposed.
```

#### Virtual Service Configuration

Our Virtual Service is defined as follows:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: homepage # The name of the Virtual Service resource.
spec:
  hosts: # Defines the hosts under the authority of this Virtual Service. The * symbol means it applies to all hosts.
    - '*'
  gateways: # Lists the gateways that this Virtual Service is bound to.
    - homepage-gateway # Binds to the previously defined homepage-gateway
  http:
    - match: # Criteria to use for matching request URIs.
        - uri:
            exact: / # Matches requests with an exact path of /.
      route:
        - destination: # Destination for routing.
            host: homepage
            port:
              number: 80
```