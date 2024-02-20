## Setup steps explained

For our setup we will need to:
- create kind cluster
- install istio
- install istio addons - (optional but recommended and included by default) 
    - istio-addons are copy from official repository [istio/samples/addons](https://github.com/istio/istio/tree/master/samples/addons) 
    - its recommended to read more about istio-addons in [official addons README.md](https://github.com/istio/istio/blob/master/samples/addons/README.md) or [istio documentation](https://istio.io/latest/docs/ops/integrations/)
- apply kustomization which provides PVC/PV/SC for cluster_volume which allows for sharing files between host and cluster's pods

> [!TIP]
>
> *`make help`*

Luckly, setup process for architecture mentioned above was automated in single `make` command:

```bash
make setup
```

Which performs the following actions:

1. **Pull Images** (`make pull-images`) - Fetches necessary Docker images for Istio and the Bookinfo sample application into. Images are pulled to host (not directly to kind cluster) from which they will be loaded into kind cluster in next steps. This allows for images to be cached on host and reduces network usage when cluster needs to be frequently recreated. 

2. **Create Cluster** (`make create-cluster`) - Initializes a kind cluster named `istio-testing`. Waits until all nodes are ready. See [kind-config.yaml](kind-cluster/kind-config.yaml) for details on config.

3. **Load Images** (`make load-images`) - Loads the pulled Docker images from host into the kind cluster.

4. **Install Istio** (`make install-istio`) - Installs Istio on the kind cluster and enables the `istio-injection` label on the default namespace. It also applies a custom Istio Ingress Gateway configuration.

5. **Apply Istio Addons** (`make apply-istio-addons`) - Installs additional Istio components, like Kiali, for enhanced observability and dashboard access.

6. **Apply Kustomize** (`make apply-kustomize`) - Applies basic kubernetes configurations like StorageClass, PersistentVolume (PV), and PersistentVolumeClaim (PVC), this will allow for sharing volume between host and pods within cluster. This allows for development with autoreload

