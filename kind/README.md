## Kind 3 worker cluster
https://kind.sigs.k8s.io/

### Install multi node cluster:
```
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64
# For ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

### Create kind cluster setup as kind-config:
```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry]
    config_path = "/etc/containerd/certs.d"
```

### Example how to create a multi node cluster
kind create cluster --name=multi-node-cluster --config=kind-config
kubectl cluster-info --context kind-multi-node-cluster

### local registry
https://kind.sigs.k8s.io/docs/user/local-registry/

### load images into cluster nodes
https://iximiuz.com/en/posts/kubernetes-kind-load-docker-image/

### see also
https://kind.sigs.k8s.io/docs/user/known-issues/
