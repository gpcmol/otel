## MetricsServer
https://github.com/kubernetes-sigs/metrics-server

### Required for HPA (Horizontal Pod Autoscaling)
wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
add --kubelet-insecure-tls to metrics-server deployment

### Install
kubens kube-system
kubectl apply -f components.yaml

### Nice reads
https://medium.com/@ravipatel.it/introduction-to-horizontal-pod-autoscaler-hpa-in-kubernetes-with-example-775babb88b6f
