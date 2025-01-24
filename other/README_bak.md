# Grafana stack

## Operator
### OpenTelemetry Operator for Kubernetes
https://opentelemetry.io/docs/kubernetes/helm/operator/
https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/connector/spanmetricsconnector/README.md

### Helm
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

opentelemetry-collector-k8s: basic collector
opentelemetry-collector-contrib: full support

helm --namespace telemetry install opentelemetry-operator open-telemetry/opentelemetry-operator \
--set "manager.collectorImage.repository=otel/opentelemetry-collector-contrib" \
--set admissionWebhooks.certManager.enabled=false \
--set admissionWebhooks.autoGenerateCert.enabled=true

helm install telemetry open-telemetry/opentelemetry-collector --set mode=<value> --set image.repository="otel/opentelemetry-collector-contrib" --set command.name="otelcol-k8s"

when needed add this:
--skip-crds

---

## Logging
### Loki
https://grafana.com/docs/loki/latest

### Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```yaml
loki:
  schemaConfig:
    configs:
      - from: "2024-10-01"
        store: tsdb
        object_store: s3
        schema: v13
        index:
          prefix: loki_index_
          period: 24h
  ingester:
    chunk_encoding: snappy
  tracing:
    enabled: true
  querier:
    # Default is 4, if you have enough memory and CPU you can increase, reduce if OOMing
    max_concurrent: 4

gateway:
  ingress:
    enabled: true
    hosts:
      - host: loki.local
        paths:
          - path: /
            pathType: Prefix

deploymentMode: Distributed

ingester:
  replicas: 3
  maxUnavailable: 2
querier:
  replicas: 3
  maxUnavailable: 2
queryFrontend:
  replicas: 2
  maxUnavailable: 1
queryScheduler:
  replicas: 2
distributor:
  replicas: 3
  maxUnavailable: 2
compactor:
  replicas: 1
indexGateway:
  replicas: 1
  maxUnavailable: 1

bloomCompactor:
  replicas: 0
bloomGateway:
  replicas: 0

# Enable minio for storage
minio:
  enabled: true

# Zero out replica counts of other deployment modes
backend:
  replicas: 0
read:
  replicas: 0
write:
  replicas: 0

singleBinary:
  replicas: 0
```
helm --namespace loki install --values values.yaml loki grafana/loki --create-namespace
helm --namespace loki upgrade --values values.yaml loki grafana/loki

---

## Collector
### Alloy
https://grafana.com/docs/alloy/latest/

### Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm --namespace alloy install alloy grafana/alloy -f values-custom.yaml --create-namespace

values changes:
```yaml
autoscaling:
  enabled: true
ingress:
  enabled: true
  hosts:
    - alloy.local
alloy:
  configMap:
    create: true
    content: |-
      logging {
        level  = "info"
        format = "logfmt"
      }
      
      discovery.kubernetes "pods" {
        role = "pod"
      }
      
      discovery.kubernetes "nodes" {
        role = "node"
      }
      
      discovery.kubernetes "services" {
        role = "service"
      }
      
      discovery.kubernetes "endpoints" {
        role = "endpoints"
      }
      
      discovery.kubernetes "endpointslices" {
        role = "endpointslice"
      }
      
      discovery.kubernetes "ingresses" {
        role = "ingress"
      }
```

helm --namespace alloy upgrade alloy grafana/alloy -f values-custom.yaml

---

## Metrics
### Mimir
https://grafana.com/docs/mimir/latest/

### Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm --namespace mimir install mimir grafana/mimir-distributed --create-namespace

---

## Traces
### Tempo
https://grafana.com/docs/tempo/latest/
https://github.com/grafana/tempo/tree/main/example/helm

### Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

---

## Grafana
### Grafana
https://grafana.com/docs/grafana/latest/

### k8s
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm --namespace grafana install grafana grafana/grafana --create-namespace
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

Setup datasources:
loki datasource: http://loki-gateway.loki.svc.cluster.local
