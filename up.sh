#!/bin/bash

if ! command -v kind &> /dev/null; then
  echo "install kind first from https://kind.sigs.k8s.io/"
  exit 1
fi

if ! command -v helm &> /dev/null; then
  echo "install helm first from https://helm.sh/docs/intro/install/"
  exit 1
fi

# create kind cluster
./kind-up-with-registry.sh

# metric server
kubens kube-system
kubectl apply -f ./metrics-server/components.yaml

# install and update helm charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

# loki
helm --namespace loki install --values ./loki/values.yaml loki grafana/loki --create-namespace

# mimir
helm --namespace mimir install --values ./mimir/values.yaml mimir grafana/mimir-distributed --create-namespace

# tempo
helm --namespace tempo install --values ./tempo/values.yaml tempo grafana/tempo-distributed --create-namespace

# grafana
helm --namespace grafana install --values ./grafana/values.yaml grafana grafana/grafana --create-namespace
grafana_password=$(kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo "Grafana admin password: $grafana_password"

# telemetry operator
helm --namespace telemetry install opentelemetry-operator open-telemetry/opentelemetry-operator --create-namespace \
--set "manager.collectorImage.repository=otel/opentelemetry-collector-contrib" \
--set admissionWebhooks.certManager.enabled=false \
--set admissionWebhooks.autoGenerateCert.enabled=true

# telemetry
helm --namespace telemetry install --values collector/values.yaml opentelemetry-collector open-telemetry/opentelemetry-collector --create-namespace

# rabbit
(
cd rabbit
./rabbit-up.sh
)

sleep 5

# add instrumentation manifest to default namespace
(
cd instrumentation
./instrument_namespace.sh default
)
