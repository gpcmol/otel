#!/bin/bash
set -o errexit

if [ $# -lt 1 ]; then
  echo "Usage: $0 clustername"
  exit 1
fi

CLUSTERNAME=$1

if ! command -v kind &> /dev/null; then
  echo "install kind first from https://kind.sigs.k8s.io/"
  exit 1
fi

if ! command -v helm &> /dev/null; then
  echo "install helm first from https://helm.sh/docs/intro/install/"
  exit 1
fi

# create kind cluster
./kind-up-with-registry.sh "$CLUSTERNAME"

kubectx kind-"$CLUSTERNAME"

# metric server
kubens kube-system
kubectl apply -f ./metrics-server/components.yaml

# install and update helm charts
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
#helm repo update

# telemetry operator
helm --namespace telemetry install opentelemetry-operator open-telemetry/opentelemetry-operator --create-namespace \
--set "manager.collectorImage.repository=otel/opentelemetry-collector-contrib" \
--set "admissionWebhooks.certManager.enabled=false" \
--set "admissionWebhooks.autoGenerateCert.enabled=true" \
--set "manager.resources.requests.cpu=100m" \
--set "manager.resources.requests.memory=128Mi" \
--set "manager.resources.limits.cpu=500m" \
--set "manager.resources.limits.memory=512Mi" \
--wait

# collector
helm --namespace telemetry install --values collector/values.yaml \
--set global.scopeOrgId="$CLUSTERNAME" \
opentelemetry-collector \
open-telemetry/opentelemetry-collector \
--create-namespace \
--wait

sleep 5

# add instrumentation manifest to default namespace
(
cd instrumentation
./instrument_namespace.sh default
)

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

#kubectl apply -f website/nginx-deployment.yaml
#kubectl apply -f ingress-routes.yaml
)
