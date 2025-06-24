#!/bin/bash
set -o errexit

if ! command -v kind &> /dev/null; then
  echo "install kind first from https://kind.sigs.k8s.io/"
  exit 1
fi

if ! command -v helm &> /dev/null; then
  echo "install helm first from https://helm.sh/docs/intro/install/"
  exit 1
fi

if [ -z "$1" ]; then
    echo "cluster name is required"
    exit 1
fi

CLUSTERNAME="$1"

# create kind cluster
kind create cluster --name "$CLUSTERNAME" --config ./kind/kind-config

kubectx kind-"$CLUSTERNAME"

# setup traefik
(
cd traefik

kubectl create namespace traefik

kubens traefik

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout tls.key -out tls.crt \
-subj "/CN=example.com/O=example.com"

kubectl create secret tls example.com \
--cert=tls.crt \
--key=tls.key \
-n traefik

#helm repo add traefik https://traefik.github.io/helm-charts
#helm repo update

helm install traefik traefik/traefik -f values.yaml

kubectl apply -f website/nginx-deployment.yaml
)

# setup collectors
(
kubectl create namespace observability
kubens observability
# https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/exporter/loadbalancingexporter/example/k8s-resolver/README.md
# https://github.com/open-telemetry/opentelemetry-operator/blob/main/docs/api/opentelemetrycollectors.md
# operator required for Trace ID aware load-balancing exporter
helm --namespace observability install opentelemetry-operator open-telemetry/opentelemetry-operator \
--set "manager.collectorImage.repository=otel/opentelemetry-collector-contrib" \
--set admissionWebhooks.certManager.enabled=false \
--set admissionWebhooks.autoGenerateCert.enabled=true --wait

helm --namespace observability upgrade opentelemetry-operator open-telemetry/opentelemetry-operator \
  --set "manager.collectorImage.repository=otel/opentelemetry-collector-contrib" \
  --set "manager.collectorImage.tag=0.128.0" \
  --set admissionWebhooks.certManager.enabled=false \
  --set admissionWebhooks.autoGenerateCert.enabled=true \
  --wait

kubectl apply -f collector/service-account.yaml

kubectl apply -f collector/tailsampling-collector.yaml

kubectl apply -f collector/loadbalancing-collector.yaml

kubectl apply -f collector/ingress-routes.yaml

# load balancer with ip exposed to network card
#cloud-provider-kind &
)
