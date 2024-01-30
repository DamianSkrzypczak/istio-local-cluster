# Istio local kind cluster setup

## Introduction

### Installation

Setup process is simplified with a Makefile that automates the creation and configuration of the kind cluster with Istio, cert-manager and sample applications. The key command you'll use is `make setup`, which encompasses several steps to get everything up and running.

### Prerequisites
Before diving into this project, ensure you have the following prerequisites installed and configured:
- [docker](https://docs.docker.com/engine/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [helm](https://helm.sh/docs/intro/install/)
- [istioctl](https://istio.io/latest/docs/setup/getting-started/#download)
- [cert-manager](https://cert-manager.io/docs/)


### Quick Start
Run the following command to set up the entire environment:

```bash
make setup
```

This command performs the following actions:

1. **Pull Images** (`make pull-images`) - Fetches necessary Docker images for Istio and the Bookinfo sample application. Images are pulled to host from which they will be loaded into kind cluster in next steps. This caches images and limits network usage for cases when cluster needs to be frequently recreated.   

2. **Create Cluster** (`make create-cluster`) -  Initializes a kind cluster named `istio-testing`. It waits until all nodes are ready.
See [kind-config.yaml](kind-cluster/kind-config.yaml) for details on config.

3. **Load Images** (`make load-images`) - Loads the pulled Docker images into the kind cluster.

4. **Install Istio** (`make install-istio`) - Installs Istio on the kind cluster and enables the `istio-injection` label on the default namespace. It also applies a custom Istio Ingress Gateway configuration.

5. **Apply Istio Addons** (`make apply-istio-addons`) - Installs additional Istio components, like Kiali, for enhanced observability and dashboard access.

6. **Apply Kustomize** (`make apply-kustomize`) - Applies Kubernetes configurations like StorageClass, PersistentVolume (PV), and PersistentVolumeClaim (PVC).

---

> [!NOTE]
>
> *everything in this repository is tailored for [kind](https://kind.sigs.k8s.io/)-specific local setup and may not be reproducible on other Istio environments.*

